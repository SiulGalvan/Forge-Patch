# HeadRush MX5 — Forge Patch Mod
_Antiguamente Compatibility Layer_

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Platform: HeadRush](https://img.shields.io/badge/MX5-red?label=HEADRUSH)]((#))
[![NAM Core](https://img.shields.io/badge/Engine-Neural%20Amp%20Modeler-green.svg)](https://github.com/sdatkinson/NeuralAmpModelerCore)
[![Release: v2.7 Extended](https://img.shields.io/badge/Release-v0.9.2%20Galvanized-success.svg)](https://github.com/iosumurillo/GIGBOARD_NAM_AMP_PNG/releases/tag/v2.7-nam-extended)

Capa de compatibilidad entre modificaciones avanzadas de firmware para **HeadRush MX5** (con posible ramificación a Pedalboard) en la version de **Firmware 2.7**, que integra de forma nativa la inferencia de redes neuronales [Neural Amp Modeler (NAM)](https://github.com/sdatkinson/NeuralAmpModelerCore) directamente en el motor de audio en tiempo real (`/usr/Evil/Evil`). 

Junto a lo anterior, se añade accesibilidad MIDI avanzada via usb para poder manejar el equipo desde Windows o Mac mediante [MX5-BRIDGE y MX-EDIT](https://github.com/TicT4x/MX-Edit).

Asi también, se integra un mod para mostrar el arte de los pedales directo en el editor de pantalla como fue mostrado en el material promocional basado en el repositorio de [GIGBOARD_NAM_PNG](https://github.com/iosumurillo/GIGBOARD_NAM_AMP_PNG) y optimizado con mejoras propias para no impactar en el rendimiento.

### ¿Cómo descargar el parche? (Releases)

Para instalar el mod en tu pedalera, existen 2 vias de sin necesidad de compilar código fuente:

| Archivo | Descripción | Descarga Directa |
| :--- | :--- | :--- |
| **Firmware Updater (NAM A2 + BRIDGE + ARTMOD)** | Flasheador automático para HeadRush MX5 ya parchado con soporte Dual NAM + MX-EDIT + ARTMOD | [Descargar .RAR]
| **Forge Patcher** | Constructor de update.img para parchar modularmente la instalación y elegir que componentes integrar | [Descargar .exe] |

> **Página de la Release**: [v0.9.2](https://github.com/iosumurillo/GIGBOARD_NAM_AMP_PNG/releases/tag/v2.7-nam-extended) 

> **Guía técnica y manual de usuario detallado**: [GUIA DE MODULOS](GUIA_MX5_0.9.2.md)

---

## Características Principales

- **Doble Bloque NAM en Cadena**:
  - **Pedal Anxiety OD (NAM)** (y Anxiety OD V2): Inferencia transparente como pedal de saturación/overdrive con controles de Input Trim, Level y selector de modelo.
- **Gráficos Integrados en Pantalla Táctil**:
  - Gráficos integrados en los recursos QML/RCC de HeadRush con soporte de NAM PEDAL y arte de la 2da generación para los pedales tipo Rack
- **MXBRIDGE**:
  - Herramienta que permite enviar y recibir señales MIDI desde un ordenador hacia la pedalera y viceversa, pilar para el funcionamiento de MXEDIT y posibles integraciones como medidor DSP.

---

## Mapeo de Controles

### Bloque Pedal: Anxiety OD (NAM)

| Control | Rango | Función Técnica |
| :--- | :--- | :--- |
| **Tone** | 0% – 100% | **Input Trim**: 50% = Ganancia Unitaria (0.0 dB). 0% = Mute, 100% = +12 dB. |
| **Drive** | 0% – 100% | **Selector de Modelo NAM**: Selecciona el archivo `.nam` correspondiente del pendrive USB (`0%` = Archivo 0, `100%` = Archivo 100). |
| **Level** | 0% – 100% | **Output Trim**: 50% = Salida Unitaria (0.0 dB). 0% = Mute, 100% = +12 dB. |
| **On/Off**| Bypass | Paso en seco directo (*dry passthrough*). |

---

## Via de instalacion
**Instalación Rápida**
1. Conecta tu HeadRush MX5 mediante USB a la PC mediante.
2. En la pedalera, entra en **Global Settings -> Firmware Update**.
3. Ejecuta `Firmware Updater (NAM A2 + BRIDGE + ARTMOD).exe` tras descargarlo de la carpeta /release o descargarlo directamente desde Releases.
4. Sigue los pasos en pantalla hasta que la pedalera complete el flasheo y reinicie.

**Instalación Personalizada**

1. Descarga `Headrush MX5 Forge Patcher 0.2.0.exe` o compilalo con `build_windows.bat` (Requieres de Phyton para ello)
2. Seleccionas que partes de los modulos necesitas, si integras el mod de arte, es necesario descargar el archivo `Rack_pedal.rar`, descomprimirlo en una carpeta y seleccionar la misma dentro del parcheador en la opción "Your rack module art". Caso contrario, los pedales tipo rack como DYNIII Compressor saldran con las graficas originales (cuadros de colores)
3. Elegir en que directorio se creara la carpeta del nuevo firmware
4. Presionar `Build Updater`
5. Realizar lo mismo que la instalación rapida

---
## Funciones experimentales (Usar bajo precaución propia)
_Estas funciones todavía se encuentran en fase de prueba y solo son accesibles mediante `Forge Patcher`, su uso de momento es estrictamente de testeo para integrarlos en actualizaciones futuras y no representan el resultado final de la integración_

- **NAM EXTENDED**: Modificación de los hilos del modulo NAM y la logica de lectura para mejorar la carga de los archivos y reducir los artefeactos
  - **Variante (Fair)**: No integra mejoras en los hilos pero si reduce la probabilidad de artefactos al cambiar de NAM al mejorar la logica de lectura.
- **MXBRIDGE-LIGHT - Integrado en 0.9.3**: Modificación de MXBRIDGE que para el MIDI USB al activar USB-AUDIO a una resolución de 48kHz o 96kHz para evitar perdida de rendimiento y relentización general del sistema
  - **Variante (Always)**: No integra esta desactivación
  - **Variante (Only)**: Desactiva el USB-MIDI al activar USB AUDIO sin importar la resolución de muestreo
- **NAM EXTENDED AMP - MUY EXPERIMENTAL/WIP**: Secuestro del modelo LEAD 800 BRIGHT para integrar controles de EQ y X2AMP con el uso de NAM, no utilizar junto a NAM de 4 instancias, ya que cargar 6 modulos NAM va a sobrecargar el sistema y puede forzar a tener que realizar un reseteo de Fabrica para salir del bucle de crasheo en arranque.

---

## Recuperación y Seguridad

El mod preserva la estructura de actualización oficial de HeadRush. Para restaurar el firmware original de fábrica en cualquier momento:
1. Pon la MX5 en modo actualización de firmware presionando los footswitch 1+2 al prender el equipo.
2. Ejecuta el actualizador oficial de HeadRush Firmware 2.7.
3. Restaurar la imagen original del sistema.

---

## Licencia

- El código del mod y los hooks de integración están bajo la licencia [GPL v3](LICENSE).
- NeuralAmpModelerCore está bajo la licencia [MIT](https://github.com/sdatkinson/NeuralAmpModelerCore/blob/main/LICENSE).
- Las marcas HeadRush, Gigboard, MX5 y Pedalboard son marcas registradas de inMusic Brands, Inc. Este proyecto es una modificación comunitaria independiente y de código abierto sin afiliación con inMusic Brands.
