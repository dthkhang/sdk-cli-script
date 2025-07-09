# Android SDK CLI Installer & Uninstaller

## Overview
This script (`sdk-cli.sh`) helps you install or uninstall the Android SDK Command Line Tools on **MacOS** and **Linux**.

> **Note:** Windows is not supported.

## Requirements
- Download the **Command line tools only** zip file for your OS from the official Android developer site:
  - [https://developer.android.com/studio#cmdline-tools](https://developer.android.com/studio#cmdline-tools)
- Make sure you have `unzip` and `sdkmanager` available in your PATH.

## Usage

**First, make the script executable:**
```sh
chmod +x sdk-cli.sh
```

### Install Android SDK Command Line Tools
```sh
./sdk-cli.sh --install /path/to/commandlinetools-xxx.zip
```
- Replace `/path/to/commandlinetools-xxx.zip` with the path to the zip file you downloaded.

### Uninstall Android SDK Command Line Tools
```sh
./sdk-cli.sh --uninstall
```

## For Pentesters
The Android SDK Command Line Tools include `apksigner`, which is useful for verifying APK signatures.

If you are performing mobile app security testing (e.g., following OWASP MASVS/MASTG), you can use `apksigner` to check if an APK is properly signed. This is relevant for:
- **MASTG-TEST-0038 / MASVS-RESILIENCE-2: Making Sure that the App is Properly Signed**

### Example: Verify APK Signature
```sh
apksigner verify --verbose --print-certs your_app.apk
```
- Replace `your_app.apk` with the path to your APK file.

For more details, see the official OWASP MASTG documentation:
- [https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0038/#overview](https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0038/#overview)

## License
This project is provided as-is for educational and testing purposes. 