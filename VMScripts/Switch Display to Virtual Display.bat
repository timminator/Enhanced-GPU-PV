@echo off
REM Switch display to external
displayswitch.exe /external

REM Delete the shortcut from the desktop
set desktopPath=%USERPROFILE%\Desktop
del "%desktopPath%\Switch Display to Virtual Display.lnk"