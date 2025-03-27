@echo off
echo Installing required dependencies for VCV Rack plugin development...

:: Create a temporary script to install jq
set "INSTALL_SCRIPT=%TEMP%\install_jq.sh"
echo #!/bin/bash > "%INSTALL_SCRIPT%"
echo echo "Updating package database..." >> "%INSTALL_SCRIPT%"
echo pacman -Syu --noconfirm >> "%INSTALL_SCRIPT%"
echo echo "Installing jq..." >> "%INSTALL_SCRIPT%"
echo pacman -S --noconfirm mingw-w64-x86_64-jq >> "%INSTALL_SCRIPT%"
echo echo "Installation completed." >> "%INSTALL_SCRIPT%"
echo read -p "Press Enter to exit..." >> "%INSTALL_SCRIPT%"

:: Run the installation script in MSYS2
echo Running installation script in MSYS2...
C:\msys64\msys2_shell.cmd -mingw64 -no-start -defterm -here -c "bash '%INSTALL_SCRIPT:\=/%'"

echo Dependencies installation completed.
pause 