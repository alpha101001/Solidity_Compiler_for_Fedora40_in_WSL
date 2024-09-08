# Solidity Compiler Installation Script

This repository contains a script named `install_solidity_compiler.sh` that automates the process of installing the Solidity compiler (`solc`) from source on **Fedora** in **WSL**. The script handles dependencies, Z3 version conflicts, uninitialized variable warnings, and ensures that users can easily install the Solidity compiler without worrying about errors or interruptions.

## Features

- Automatically installs all necessary dependencies for building Solidity.
- Clones the official Solidity GitHub repository and checks out the specified version.
- Handles potential Z3 version conflicts by disabling strict version checks.
- Compiles Solidity with dynamic Boost libraries, resolving common build issues.
- Automatically disables uninitialized variable warnings that would otherwise halt the build.
- Gracefully handles errors and warnings, allowing the user to proceed without manual intervention.

## Requirements

- **Fedora** running on **Windows Subsystem for Linux (WSL)**.
- **Git**, **CMake**, **GCC**, and **Boost** should be installed, but the script will ensure dependencies are managed.

## Usage

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/<your-username>/<your-repository-name>.git
cd <your-repository-name>

2. Make the Script Executable
Make the installation script executable:

chmod +x install_solidity_compiler.sh

3. Run the Script
Execute the script to install Solidity:

./install_solidity_compiler.sh

The script will handle everything from installing dependencies, cloning the Solidity repository, building the compiler, and verifying the installation.


What the Script Does
Installs Dependencies: The script installs cmake, gcc-c++, boost-devel, boost-static, git, and z3-devel. If dependencies are already installed, the script proceeds without issues.

Clones or Updates the Solidity Repository: If the Solidity repository is not present, it clones the latest version. If it already exists, the script updates it.

Builds Solidity:

The script ensures dynamic Boost libraries are used to avoid library linking issues.
If Z3 is installed but the version does not match the required version (4.12.1), the script disables strict Z3 version checking to avoid build failures.
If Z3 is not installed, the script disables Z3 entirely, allowing the build to proceed without SMTChecker support.
Warnings for uninitialized variables are ignored to prevent the build from failing.
Installs Solidity: After building, the script installs the solc compiler system-wide.

Verifies Installation: After installation, the script verifies that solc is correctly installed by checking its version.


Example Output
Upon successful execution, the script should output something like:

Verifying Solidity installation...
solc, the Solidity compiler commandline interface
Version: 0.8.21
Solidity (solc) installation script has completed.


Customization
Specify Solidity Version
If you need to install a different version of Solidity, you can modify the SOLC_VERSION variable in the script:

SOLC_VERSION="v0.8.21"  # Change this to your desired version


Error Handling
The script is designed to handle errors gracefully. If any step fails (e.g., cloning the repository or building the compiler), the script logs a warning and continues, ensuring that you don't have to intervene manually.

Contributing
If you encounter issues or have suggestions for improvements, feel free to open a pull request or an issue in this repository.

License
This project is licensed under the MIT License - see the LICENSE file for details.



### Key Sections in the Documentation:
- **Features**: Lists the key capabilities of the script, so users understand what it does.
- **Requirements**: Explains the prerequisites for using the script, specific to Fedora on WSL.
- **Usage**: Clear step-by-step instructions on how to execute the script.
- **What the Script Does**: Describes each part of the script’s functionality, so users know what to expect.
- **Customization**: Explains how users can easily change the version of Solidity they want to install.
- **Example Output**: Provides an example of what a successful execution looks like.
- **Contributing**: Encourages contributions for improvements or issues.

### How to Use:
- Copy this content into a `README.md` file in your repository.
- Replace `<your-username>` and `<your-repository-name>` with your GitHub username and repository name.

This `README.md` will ensure that anyone using your script can easily understand and follow the installation process without issues. Let me know if you need any further changes!
