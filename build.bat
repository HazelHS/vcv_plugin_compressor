@echo off
echo Running VCV Rack Plugin Build Script

:: Change to the plugin directory and run the build script
cd "%~dp0plugin"
call build.bat

:: Return to the original directory
cd "%~dp0"

echo Build process completed from root directory.
pause 