@echo off
rem Builds dist\mx5forge.exe (needs Python 3.9+ from python.org, with "Add to PATH" and tcl/tk).
cd /d "%~dp0"
python -m pip install -r requirements.txt pyinstaller || goto :err
python -m PyInstaller --noconfirm --onefile --windowed --name mx5forge ^
  --paths . --paths mx5forge\vendor\mxedit ^
  --add-data "mx5forge\nam\blobs;mx5forge\nam\blobs" ^
  --add-data "mx5forge\art\assets;mx5forge\art\assets" ^
  --add-data "mx5forge\art\manifest_mx5_2.7.json;mx5forge\art" ^
  --add-data "mx5forge\vendor\mxedit;mx5forge\vendor\mxedit" ^
  packaging\entry.py || goto :err
echo.
echo Listo: dist\mx5forge.exe
pause
exit /b 0
:err
echo Fallo la compilacion.
pause
exit /b 1
