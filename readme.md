# VCV Rack Compressor Plugin

A simple audio compressor module for VCV Rack 2.

## Building the Plugin

### Prerequisites

1. Install MSYS2 from https://www.msys2.org/
2. Install the MinGW toolchain and dependencies:
   ```
   ./install-deps.bat
   ```

### Building

To build the plugin, simply run:
```
./build-msys.bat
```

This will:
1. Compile the plugin code
2. Create a .vcvplugin file
3. Install the plugin to your Rack2 installation

## Development Notes

- The build process uses MSYS2 to compile the plugin
- The Rack-SDK folder contains the VCV Rack SDK
- Plugin source code is in the `plugin/src` directory
- Plugin resources (SVG files, etc.) are in the `plugin/res` directory

## Troubleshooting

If you encounter build errors:

1. Make sure MSYS2 is installed at `C:\msys64`
2. Run `install-deps.bat` to install required dependencies
3. Check that the Rack-SDK folder contains the VCV Rack SDK
4. Ensure that your `plugin.json` file correctly describes your plugin

## License

MIT