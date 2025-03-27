@echo off
setlocal enabledelayedexpansion

echo Building VCV Rack plugin...

:: Check common MSYS2 installation paths
set "MSYS2_PATHS=C:\msys64;C:\msys2;D:\msys64;D:\msys2"
set "MSYS2_FOUND=0"

for %%p in (%MSYS2_PATHS%) do (
    if exist "%%p" (
        set "MSYS2_PATH=%%p"
        set "MSYS2_FOUND=1"
        echo Found MSYS2 at %%p
    )
)

if %MSYS2_FOUND% equ 0 (
    echo ERROR: MSYS2 installation not found.
    echo Please install MSYS2 from https://www.msys2.org/
    echo If MSYS2 is already installed, update this script with your installation path.
    pause
    exit /b 1
)

:: Check for MinGW
set "MINGW_PATH=%MSYS2_PATH%\mingw64\bin"
if not exist "%MINGW_PATH%" (
    echo ERROR: MinGW not found at %MINGW_PATH%
    echo Make sure you have installed the mingw-w64-x86_64-toolchain using MSYS2.
    echo Run the following command in MSYS2:
    echo pacman -S mingw-w64-x86_64-toolchain
    pause
    exit /b 1
)

:: Check for make executable
set "MAKE_EXES=mingw32-make.exe;make.exe"
set "MAKE_FOUND=0"

for %%e in (%MAKE_EXES%) do (
    if exist "%MINGW_PATH%\%%e" (
        set "MAKE_EXE=%%e"
        set "MAKE_FOUND=1"
        echo Found make at %MINGW_PATH%\%%e
    )
)

if %MAKE_FOUND% equ 0 (
    echo ERROR: No make executable found in %MINGW_PATH%
    echo Make sure you have installed the mingw-w64-x86_64-toolchain using MSYS2.
    echo Run the following command in MSYS2:
    echo pacman -S mingw-w64-x86_64-toolchain
    pause
    exit /b 1
)

:: Set paths with proper backslashes for Windows
set "PLUGIN_DIR=%~dp0"
set "ROOT_DIR=%PLUGIN_DIR%.."
set "RACK_DIR=%ROOT_DIR%\Rack-SDK"

:: Verify SDK directory exists
if not exist "%RACK_DIR%" (
    echo ERROR: Rack-SDK directory not found at %RACK_DIR%
    echo Make sure you have downloaded the VCV Rack SDK and placed it in the Rack-SDK folder.
    pause
    exit /b 1
)

:: Check for arch.mk in SDK
if not exist "%RACK_DIR%\arch.mk" (
    echo ERROR: arch.mk not found in the Rack-SDK directory
    echo Please make sure you have the correct VCV Rack SDK files.
    echo Download the SDK from https://vcvrack.com/downloads
    pause
    exit /b 1
)

:: Verify Makefile exists
if not exist "%PLUGIN_DIR%Makefile" (
    echo ERROR: Makefile not found in %PLUGIN_DIR%
    echo Your plugin directory must contain a valid Makefile.
    pause
    exit /b 1
)

:: Make sure build directory exists
if not exist "%PLUGIN_DIR%build" (
    mkdir "%PLUGIN_DIR%build"
)

:: Make sure paths are in the correct format (use forward slashes for Make)
:: Remove any trailing backslash and convert remaining to forward slashes
set "PLUGIN_DIR_MAKE=%PLUGIN_DIR:~0,-1%"
set "PLUGIN_DIR_MAKE=%PLUGIN_DIR_MAKE:\=/%"
set "RACK_DIR_MAKE=%RACK_DIR:\=/%"

:: Remove any quotes in the paths
set "PLUGIN_DIR_MAKE=%PLUGIN_DIR_MAKE:"=%"
set "RACK_DIR_MAKE=%RACK_DIR_MAKE:"=%"

:: Add MinGW to PATH
set "PATH=%MINGW_PATH%;%PATH%"

:: Go to plugin directory
cd "%PLUGIN_DIR%"

echo Building plugin...
echo PLUGIN_DIR=%PLUGIN_DIR_MAKE%
echo RACK_DIR=%RACK_DIR_MAKE%
echo MAKE_EXE=%MINGW_PATH%\%MAKE_EXE%

:: Clean previous build files
echo Cleaning previous build...
if exist "build" rmdir /s /q "build"
mkdir "build"

:: Run make commands with properly formatted paths and no quotes
echo Running make dep...
"%MINGW_PATH%\%MAKE_EXE%" -f Makefile RACK_DIR=%RACK_DIR_MAKE% dep
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Make dep failed
    pause
    exit /b %ERRORLEVEL%
)

echo Running make install...
"%MINGW_PATH%\%MAKE_EXE%" -f Makefile RACK_DIR=%RACK_DIR_MAKE% install
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Make install failed
    pause
    exit /b %ERRORLEVEL%
)

echo Build completed successfully!
pause
exit /b 0