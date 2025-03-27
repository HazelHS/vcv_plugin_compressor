@echo off
echo Building VCV Rack plugin using MSYS2...

:: Set paths
set "ROOT_DIR=%~dp0"
set "PLUGIN_DIR=%ROOT_DIR%plugin"
set "RACK_DIR=%ROOT_DIR%Rack-SDK"

:: Check that the directories exist
if not exist "%PLUGIN_DIR%" (
    echo ERROR: Plugin directory not found at %PLUGIN_DIR%
    pause
    exit /b 1
)

if not exist "%RACK_DIR%" (
    echo ERROR: Rack-SDK directory not found at %RACK_DIR%
    pause
    exit /b 1
)

if not exist "%PLUGIN_DIR%\Makefile" (
    echo ERROR: Makefile not found in plugin directory
    pause
    exit /b 1
)

:: Create a build script for MSYS2
set "BUILD_SCRIPT=%TEMP%\vcv_build.sh"
echo #!/bin/bash > "%BUILD_SCRIPT%"
echo echo "Building VCV Rack plugin..." >> "%BUILD_SCRIPT%"
echo WORKDIR="%ROOT_DIR:\=/%" >> "%BUILD_SCRIPT%"
echo PLUGIN_DIR="%PLUGIN_DIR:\=/%" >> "%BUILD_SCRIPT%"
echo RACK_DIR="%RACK_DIR:\=/%" >> "%BUILD_SCRIPT%"
echo echo "WORKDIR: $WORKDIR" >> "%BUILD_SCRIPT%"
echo echo "PLUGIN_DIR: $PLUGIN_DIR" >> "%BUILD_SCRIPT%"
echo echo "RACK_DIR: $RACK_DIR" >> "%BUILD_SCRIPT%"

:: Set PATH to include jq
echo export PATH="/mingw64/bin:$PATH" >> "%BUILD_SCRIPT%"
echo echo "Checking for jq:" >> "%BUILD_SCRIPT%"
echo which jq >> "%BUILD_SCRIPT%"
echo if [ $? -ne 0 ]; then >> "%BUILD_SCRIPT%"
echo   echo "jq not found. Please run install-deps.bat first." >> "%BUILD_SCRIPT%"
echo   read -p "Press Enter to exit..." >> "%BUILD_SCRIPT%"
echo   exit 1 >> "%BUILD_SCRIPT%"
echo fi >> "%BUILD_SCRIPT%"

echo cd "$PLUGIN_DIR" >> "%BUILD_SCRIPT%"
echo echo "Current directory: $(pwd)" >> "%BUILD_SCRIPT%"
echo export RACK_DIR="$RACK_DIR" >> "%BUILD_SCRIPT%"
echo echo "Running make clean..." >> "%BUILD_SCRIPT%"
echo make clean >> "%BUILD_SCRIPT%"
echo echo "Running make dep..." >> "%BUILD_SCRIPT%"
echo make dep >> "%BUILD_SCRIPT%"
echo echo "Running make install..." >> "%BUILD_SCRIPT%"
echo make install >> "%BUILD_SCRIPT%"
echo echo "Build completed." >> "%BUILD_SCRIPT%"
echo read -p "Press Enter to exit..." >> "%BUILD_SCRIPT%"

:: Run the build script in MSYS2
echo Running build script in MSYS2...
C:\msys64\msys2_shell.cmd -mingw64 -no-start -defterm -here -c "bash '%BUILD_SCRIPT:\=/%'"

echo Build process completed.
pause 