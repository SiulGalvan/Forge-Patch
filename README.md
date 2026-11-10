# HeadRush MX5 Forge

Build a patched **HeadRush MX5 (firmware 2.7)** updater on your own computer:

* downloads the official updater from inMusic (or uses a file you already have),
* applies the **NAM mod** (Neural Amp Modeler on the Anxiety OD pedal) with **2 or 4 instances**,
* adds the **MX5 Bridge** (USB-MIDI bridge used by [MX-Edit](https://github.com/)),
* optionally applies the **pedal design** (NAM pedal art + pedal pictures in the signal chain) (with 2 instances Anxiety OD V2 keeps its original art; with 4 it gets the NAM badge),
* writes a ready-to-run `FirmwareUpdater` folder.

> Unofficial. Flashing modified firmware can brick your device. Recovery: hold footswitches 1 + 2 while powering on and flash the official updater. You do it at your own risk.

## Modes

| | 2 instances | 4 instances |
|---|---|---|
| Anxiety OD | NAM pedal | NAM pedal |
| Anxiety OD V2 | untouched | NAM pedal (loses its original sound) |
| Pedal pictures | optional **pedal design** (V2 keeps its original art) | optional **pedal design** (V2 gets the NAM badge) |
| MX5 Bridge | optional | optional |

The pedal design works with both builds. With 2 instances only Anxiety OD gets the NAM art and Anxiety OD V2 keeps its original picture; with 4 instances V2 gets the NAM badge too.

## NAM engines and the NAM amp (0.2.0)

* `--engine nam-mod` (default): the nam-mod 0.1.6 libraries, the ones proven on an MX5.
* `--engine extended`: the NAM Extended libraries. The inference code is the same; the differences are gentler background threads
  (`SCHED_IDLE`, small sleeps while a model is built / warmed up) to avoid glitches when loading or switching a model.
  Not tested on an MX5. On a single-core device the background loading only advances when the audio thread leaves CPU free, so with 4 heavy models loading may be slow - please report.
* `--amp` (**experimental**, needs `--engine extended`): also hijacks the amp class `AmpCab`, so the **82 LEAD 800 Bright** amp block runs a NAM model
  (Gain / Presence / Master, Bass / Mid / Treble, Depth = model selector, Bright = tight-cut HPF). The MX5 addresses were derived from the MX5 2.7 Evil
  (vtable `0x15e737c`, process() `0x139538`, slot 7) and the object offsets used by the hook were checked in the disassembly, but the amp model id the hook looks for
  (27 or 37) and the audio path were only verified on a Gigboard. No amp art / rename is applied. It has never run on an MX5.

## Use

```bash
pip install -r requirements.txt          # Pillow (GUI needs tkinter, part of the usual Python installers)
python -m mx5forge                       # graphical interface
python -m mx5forge --instances 4 --design --rack-art ./my_racks --out ./out     # command line
python -m mx5forge --instances 2 --no-bridge --input FirmwareUpdater_MX5.zip
python -m mx5forge --instances 4 --engine extended --amp   # experimental
```

Then run `FirmwareUpdater.exe` from the output folder (copy it, `libusb-1.0.dll` and `Background.png` from the official
updater if the tool tells you they are missing) and press the install button.
Output folder names: `HeadRush_MX5_2.7_NAM<2|4>[_Bridge][_Design]_Updater`.

Pedal design with your own rack-module pictures: see `mx5forge/art/rack_art/README.md`.

## How it works

`mx5forge/pipeline.py` runs: download/unpack -> verify the FIT image -> open the ext4 rootfs -> **NAM** (`nam/`: redirects the
Anxiety OD process() vtable slot to a trampoline, installs `libnam_hook.so`/`libnam_preload.so`, edits the launcher script)
-> **design** (`art/`: patches the stock `ActiveStomp.qml` read from the firmware itself, pre-scales the pedal pictures,
bypasses the precompiled QML unit) -> **MX5 Bridge** (`vendor/mxedit/`) -> verify every written file -> recompress -> rebuild the FIT.
Everything is checked against what is expected in the MX5 2.7 firmware and refuses to continue otherwise.
Details: [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md).

## What has been tested

* The Python NAM patch reproduces, byte for byte, the Evil binary, libraries and scripts of a real 2-instance MX5 image made with the original nam-mod + MX-Edit (that image is known to run on hardware).
* The complete pipeline was run offline on a stock-equivalent image for 2 instances + Bridge and 4 instances + Bridge + design.
* The design (QML + images) corresponds to builds that were tested on a real MX5 (chain art, wah modules, pre-scaled pictures).

**Not tested:** the online download (needs network access to inMusic), the graphical interface (it needs tkinter, not available where this was written), and the **4-instance hijack of Anxiety OD V2 together with the pedal design on hardware**. Please report results.

## Layout

```
mx5forge/            application (cli.py, gui.py, pipeline.py)
  nam/               NAM hijack: elfpatch.py, launcher.py, blobs/ (nam-mod 0.1.6 build output)
  art/               pedal design: qmlport.py, images.py, apply.py, manifest_mx5_2.7.json, assets/
  vendor/mxedit/     MX-Edit firmware tools (MIT): ext4, FIT, xz, 7z, download, MX5 Bridge
nam_source_extended/ sources of the NAM Extended libraries (GPL)
nam_source_patch/    sources of libnam_hook / libnam_preload (from nam-mod, GPL)  - to rebuild the blobs
nam_build_scripts/   build scripts of nam-mod for those blobs
tests/               python -m unittest discover -s tests      (set MX5_STOCK_EVIL=... for the art tests)
```

Licenses and origins: [THIRD_PARTY.md](THIRD_PARTY.md). This project is GPL-3.0 because it contains ported nam-mod code.

> `--engine extended-fair`: the Extended hook with its `SCHED_IDLE` / `nice(19)` background-thread priority neutralised (`tools/make_extended_fair.py`).
> Reported on an MX5: plain `extended` slowed the device and skipped rigs in USB Audio 48 kHz mode; `extended-fair` is the candidate fix (untested).

> **Bridge and USB audio.** On the tested MX5, the Bridge's USB-MIDI function inside the USB-audio gadget made the device slow down when recording over USB audio at **48 kHz**
> (about 110,000 USB interrupts per second instead of about 8,000), but not at 44.1 kHz. `--audio-midi auto` (default) therefore adds that function at every rate except 48 kHz and 96 kHz (96 kHz is treated like 48 kHz by request, it has not been measured),
> `on` always adds it (original Bridge) and `off` never ('lite'). With the function missing, MX-Edit connects only while USB audio is idle. The rate is the first argument of
> `usb-otg-audio-start.sh`; only 44.1 and 48 kHz have been measured.

## Windows executable (.exe)

- **Nothing to install:** on GitHub open *Actions* → workflow *build* → *Run workflow*, then download the `mx5forge-windows-latest` artifact (contains `mx5forge.exe`).
- **On your PC:** install Python 3.9+ (with tcl/tk, "Add to PATH") and double-click `build_windows.bat`; the result is `dist\mx5forge.exe`.
- Double-clicking the `.exe` opens the GUI where the modules are selected. The official firmware is downloaded by the program itself and is not bundled.
