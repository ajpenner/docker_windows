@echo off
REM Variables are available for all users
set "STARTUP=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

if not exist "%STARTUP%" mkdir "%STARTUP%"

copy /Y "C:\OEM\import-env.ps1" "C:\OEM\import-env.ps1"
copy /Y "C:\OEM\import-env.cmd" "%STARTUP%\import-env.cmd"

echo install.bat ran at %date% %time% > C:\OEM\install.log
echo Startup folder: %STARTUP% >> C:\OEM\install.log
dir "%STARTUP%" >> C:\OEM\install.log 2>&1
