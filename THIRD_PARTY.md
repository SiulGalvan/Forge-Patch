# Third-party code and assets

| Part | Origin | License |
|---|---|---|
| `mx5forge/nam/` (ELF hijack, launcher script), `nam_source_patch/`, `nam_build_scripts/`, `mx5forge/nam/blobs/` | headrush-nam-mod 0.1.6 (Python port of `core/elf_patch.c`, `core/launcher_script.c`, `core/model_targets.c`; blobs are its build output: `libnam_hook.so`, `libnam_preload.so`, `trampoline_gonk.bin`) | GPL-3.0 (see `LICENSE`, `THIRD_PARTY_LICENSES_nam-mod.md`) |
| NeuralAmpModelerCore inside `libnam_hook.so` | Steven Atkinson et al. | MIT (details in `THIRD_PARTY_LICENSES_nam-mod.md`) |
| `mx5forge/vendor/mxedit/` (FIT/ext4/xz/7z handling, MX5 Bridge scripts, download) | MX-Edit 0.9.5 firmware tools | MIT (`mx5forge/vendor/mxedit/LICENSE`) |
| `mx5forge/vendor/mxedit/bin/sqlite3` | SQLite built for the MX5 (ARM) as shipped with MX-Edit | public domain |

Not included and never to be added: any HeadRush/inMusic firmware, binary or QML. The tool reads them
from the official updater on the user's own computer and patches them there.

## Additions in 0.2.0

| Component | Origin | License | Notes |
|---|---|---|---|
| `mx5forge/nam/blobs/extended/libnam_hook.so`, `libnam_preload.so` | Gigboard_NAM (NAM Extended) build output | GPL-3 | sources in `nam_source_extended/` (nam_hook.cpp, nam_preload.cpp, build scripts); NeuralAmpModelerCore (MIT) is fetched by `fetch_nam_core.sh` |
| `mx5forge/vendor/mxedit/bridgepatch.py` | MX-Edit 0.9.5 | MIT | **one modified line**: the launcher regex also accepts `NAM_HOOK_SLOT_AMP_ADDR` / `NAM_ORIG_AMP_PROCESS_ADDR` |
| `mx5forge/nam/blobs/extended-fair/libnam_hook.so` | derived from the Extended hook by `tools/make_extended_fair.py` (6 call sites neutralised) | GPL-3 | same sources as `nam_source_extended/`, minus the `lower_background_thread_priority()` effect |
| `mx5forge/vendor/mxedit/bridgepatch.py` (2nd change) | MX-Edit 0.9.5 | MIT | module switch `AUDIO_MIDI` (default True = unchanged behaviour) to omit the MIDI function inside the USB-audio gadget |
| `mx5forge/vendor/mxedit/bridgepatch.py` (3rd change) | MX-Edit 0.9.5 | MIT | module switch `DAEMONS` (default True = unchanged) for diagnostic builds |
| `mx5forge/vendor/mxedit/bridgepatch.py` + `mod/mx5bridge-usb.sh` (4th change) | MX-Edit 0.9.5 | MIT | `PROBE` switch / `#@PROBE@` marker for a diagnostic build |
| `mx5forge/vendor/mxedit/bridgepatch.py` (5th change) | MX-Edit 0.9.5 | MIT | `AUDIO_MIDI = 'auto'`: MIDI function in the audio gadget except at 48 and 96 kHz |

mx5forge change to the vendored ext4.py: `_data_runs` now also handles extent trees of depth > 0 (stock firmware files can be fragmented) and returns their index blocks so they are freed when a file is replaced.
