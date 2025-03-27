@echo off
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:\=/%"

REM Create temporary directories
if not exist C:\temp mkdir C:\temp

echo Downloading SDK with PowerShell...
powershell -Command "try { (New-Object System.Net.WebClient).DownloadFile('https://vcvrack.com/downloads/Rack-SDK-2.3.0-win-x64.zip', '%SCRIPT_DIR%sdk.zip') } catch { Write-Host $_.Exception.Message }"
powershell -Command "try { Expand-Archive -Force '%SCRIPT_DIR%sdk.zip' -DestinationPath '%SCRIPT_DIR%' } catch { Write-Host $_.Exception.Message }"

REM Rename with a different method to avoid access denied errors
powershell -Command "if ((Test-Path '%SCRIPT_DIR%Rack-SDK') -and (-not (Test-Path '%SCRIPT_DIR%sdk'))) { robocopy '%SCRIPT_DIR%Rack-SDK' '%SCRIPT_DIR%sdk' /E /MOVE /R:1 /W:1 }"

powershell -Command "if (Test-Path '%SCRIPT_DIR%sdk.zip') { Remove-Item '%SCRIPT_DIR%sdk.zip' }"

REM Create the plugin.json file directly
echo Creating plugin.json file...
if not exist "%SCRIPT_DIR%plugin" mkdir "%SCRIPT_DIR%plugin"
if not exist "%SCRIPT_DIR%plugin\res" mkdir "%SCRIPT_DIR%plugin\res"
if not exist "%SCRIPT_DIR%plugin\src" mkdir "%SCRIPT_DIR%plugin\src"

echo { > "%SCRIPT_DIR%plugin\plugin.json"
echo   "slug": "plugin", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "name": "Plugin", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "version": "2.0.0", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "license": "MIT", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "brand": "VCV", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "author": "VCV", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "authorEmail": "", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "authorUrl": "", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "pluginUrl": "", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "manualUrl": "", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "sourceUrl": "", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "donateUrl": "", >> "%SCRIPT_DIR%plugin\plugin.json"
echo   "modules": [] >> "%SCRIPT_DIR%plugin\plugin.json"
echo } >> "%SCRIPT_DIR%plugin\plugin.json"

REM Create a Python script to handle the module creation non-interactively
echo import os, sys, subprocess > C:\temp\create_module.py
echo print("Creating module with Python...") >> C:\temp\create_module.py
echo os.chdir(r"%SCRIPT_DIR%plugin") >> C:\temp\create_module.py
echo print("Working directory:", os.getcwd()) >> C:\temp\create_module.py
echo module_script = r"../sdk/helper.py" >> C:\temp\create_module.py
echo module_name = "module1" >> C:\temp\create_module.py
echo panel_filename = "./res/module1.svg" >> C:\temp\create_module.py
echo source_filename = "./src/module1.cpp" >> C:\temp\create_module.py
echo print("Running helper.py...") >> C:\temp\create_module.py
echo # Use subprocess to run the helper.py script with input >> C:\temp\create_module.py
echo cmd = [sys.executable, module_script, "createmodule", module_name, panel_filename, source_filename] >> C:\temp\create_module.py
echo process = subprocess.Popen( >> C:\temp\create_module.py
echo     cmd, >> C:\temp\create_module.py
echo     stdin=subprocess.PIPE, >> C:\temp\create_module.py
echo     stdout=subprocess.PIPE, >> C:\temp\create_module.py
echo     stderr=subprocess.PIPE, >> C:\temp\create_module.py
echo     universal_newlines=True >> C:\temp\create_module.py
echo ) >> C:\temp\create_module.py
echo # Send the inputs needed for interactive prompts >> C:\temp\create_module.py
echo stdout, stderr = process.communicate("module1\n\n\n") >> C:\temp\create_module.py
echo print("STDOUT:", stdout) >> C:\temp\create_module.py
echo print("STDERR:", stderr) >> C:\temp\create_module.py
echo if process.returncode != 0: >> C:\temp\create_module.py
echo     print("Error: Command failed with return code", process.returncode) >> C:\temp\create_module.py
echo else: >> C:\temp\create_module.py
echo     print("Module created successfully!") >> C:\temp\create_module.py
echo # Now return to the original directory and apply the patch >> C:\temp\create_module.py
echo os.chdir(r"%SCRIPT_DIR%") >> C:\temp\create_module.py
echo if os.path.exists(".patch/patch.diff"): >> C:\temp\create_module.py
echo     print("Applying patch...") >> C:\temp\create_module.py
echo     subprocess.call(["C:\\msys64\\usr\\bin\\patch.exe", "-p1", "-i", ".patch/patch.diff"]) >> C:\temp\create_module.py
echo else: >> C:\temp\create_module.py
echo     print("Warning: Patch file not found") >> C:\temp\create_module.py
echo # Build the plugin >> C:\temp\create_module.py
echo print("Building...") >> C:\temp\create_module.py
echo os.chdir(r"%SCRIPT_DIR%plugin") >> C:\temp\create_module.py
echo subprocess.call(["C:\\msys64\\usr\\bin\\make.exe", "clean", "dep"]) >> C:\temp\create_module.py
echo subprocess.call(["C:\\msys64\\usr\\bin\\make.exe", "dist"]) >> C:\temp\create_module.py
echo print("Setup complete!") >> C:\temp\create_module.py

REM Execute the Python script
py C:\temp\create_module.py

REM Clean up
del C:\temp\create_module.py