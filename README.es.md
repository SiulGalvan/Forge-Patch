# HeadRush MX5 Forge

Crea en tu propio ordenador un instalador parcheado para el **HeadRush MX5 (firmware 2.7)**:

* descarga el actualizador oficial de inMusic (o usa un archivo que ya tengas),
* aplica el **NAM mod** (Neural Amp Modeler en el pedal Anxiety OD) con **2 o 4 instancias**,
* añade el **MX5 Bridge** (el puente USB-MIDI que usa MX-Edit),
* aplica opcionalmente el **diseño de pedales** (arte del pedal NAM e imágenes de pedal en la cadena), con 2 instancias Anxiety OD V2 conserva su arte original; con 4 recibe la insignia NAM,
* deja una carpeta con `FirmwareUpdater` lista para ejecutar.

> No oficial. Flashear firmware modificado puede dejar el equipo inservible. Recuperación: mantén pulsados los footswitches 1 + 2 al encender y flashea el actualizador oficial. Úsalo bajo tu responsabilidad.

## Modos

| | 2 instancias | 4 instancias |
|---|---|---|
| Anxiety OD | pedal NAM | pedal NAM |
| Anxiety OD V2 | sin tocar | pedal NAM (pierde su sonido original) |
| Imágenes de pedales | **diseño** opcional (V2 conserva su arte) | **diseño** opcional (V2 con insignia NAM) |
| MX5 Bridge | opcional | opcional |

## Motores NAM y amp NAM (0.2.0)

* `--engine nam-mod` (por defecto): las librerías del nam-mod 0.1.6, probadas en un MX5.
* `--engine extended`: las librerías del NAM Extended. La inferencia es la misma; cambian los hilos de fondo (`SCHED_IDLE`, pausas cortas al construir y precalentar un modelo) para evitar glitches al cargar o cambiar de modelo. Sin probar en un MX5. En un equipo de un solo núcleo la carga en segundo plano solo avanza cuando el audio deja CPU libre; con 4 modelos pesados podría tardar: se agradece que reportes.
* `--amp` (**experimental**, requiere `--engine extended`): secuestra también la clase `AmpCab`, de modo que el bloque de amplificador **82 LEAD 800 Bright** ejecuta un modelo NAM (Gain / Presence / Master, Bass / Mid / Treble, Depth = selector de modelo, Bright = filtro paso altos). Las direcciones del MX5 se derivaron del Evil 2.7 del MX5 (vtable `0x15e737c`, process() `0x139538`, slot 7) y se comprobaron en el desensamblado los offsets del objeto que usa el hook, pero el ID de modelo de amp que busca el hook (27 o 37) y el camino de audio solo se verificaron en Gigboard. No se aplica arte ni renombrado del amp. Nunca se ha ejecutado en un MX5.

## Uso

```bash
pip install -r requirements.txt          # Pillow (la interfaz necesita tkinter)
python -m mx5forge                       # interfaz gráfica
python -m mx5forge --instances 4 --design --rack-art ./mis_racks --out ./salida
python -m mx5forge --instances 2 --no-bridge --input FirmwareUpdater_MX5.zip
python -m mx5forge --instances 4 --engine extended --amp   # experimental
```

Después ejecuta `FirmwareUpdater.exe` desde la carpeta de salida (si la herramienta indica que faltan `FirmwareUpdater.exe`,
`libusb-1.0.dll` o `Background.png`, cópialos del actualizador oficial) y pulsa el botón de instalar.

Para el diseño con tus propias imágenes de módulos tipo rack, mira `mx5forge/art/rack_art/README.md`.
Nada de HeadRush se incluye en el repositorio: la herramienta lee todo del actualizador oficial en tu ordenador.

## Qué está probado

* El parche NAM en Python reproduce byte a byte el binario Evil, las librerías y los scripts de una imagen MX5 real de 2 instancias hecha con el nam-mod original y MX-Edit (imagen que funciona en el equipo).
* El proceso completo se ejecutó sin conexión sobre una imagen equivalente a la original con 2 + Bridge, con 2 + Bridge + diseño y con 4 + Bridge + diseño.
* El diseño (QML + imágenes) corresponde a versiones probadas en un MX5 real.

**No probado:** la descarga en línea, la interfaz gráfica (requiere tkinter) y, en el equipo, la combinación de **4 instancias con Anxiety OD V2 secuestrado y el diseño de pedales**. Se agradece que reportes resultados.

Licencias y orígenes: [THIRD_PARTY.md](THIRD_PARTY.md). El proyecto es GPL-3.0 porque incluye código portado del nam-mod.

> **Bridge y audio USB.** En el MX5 probado, la función USB-MIDI del Bridge dentro del dispositivo de audio USB ralentizaba el equipo al grabar a **48 kHz** (unas 110.000 interrupciones USB por segundo en lugar de unas 8.000), pero no a 44,1 kHz. Por eso `--audio-midi auto` (por defecto) añade esa función a todas las frecuencias salvo 48 y 96 kHz (96 kHz se trata como 48 kHz por petición, no se ha medido); `on` la añade siempre (Bridge original) y `off` nunca (versión «lite»). Sin la función, MX-Edit solo conecta mientras el audio USB está inactivo. Solo se han medido 44,1 y 48 kHz.

## Ejecutable de Windows (.exe)

- **Sin instalar nada:** en GitHub, pestaña *Actions* → workflow *build* → *Run workflow*. Al terminar, descarga el artefacto `mx5forge-windows-latest` (contiene `mx5forge.exe`).
- **En tu PC:** instala Python 3.9+ (con tcl/tk y "Add to PATH") y haz doble clic en `build_windows.bat`; el resultado queda en `dist\mx5forge.exe`.
- Doble clic en el `.exe` abre la interfaz gráfica, donde eliges los módulos (NAM 2/4, motor, Bridge, diseño…). Sin ventana, `mx5forge.exe --help` muestra la línea de comandos. El firmware oficial lo descarga el propio programa; no va incluido.
