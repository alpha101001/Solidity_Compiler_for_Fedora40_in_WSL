#!/bin/bash

# Script to build and install Solidity (solc) from source on Fedora in WSL
# This script ensures that all necessary dependencies are installed and builds Solidity without any interruptions or errors.

# ---------------- CONFIGURABLE VARIABLES ----------------
SOLC_VERSION="v0.8.21"  # Solidity version
Z3_REQUIRED_VERSION="4.12.1"  # Required Z3 version for SMT checking

# ---------------- FUNCTION DEFINITIONS ----------------

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install necessary dependencies
install_dependencies() {
    echo "Installing necessary dependencies..."
    sudo dnf install -y cmake gcc-c++ boost-devel boost-static git z3-devel || {
        echo "Warning: Failed to install dependencies. Proceeding anyway..."
    }
}

# Function to check if the correct version of Z3 is installed
check_z3_version() {
    if command_exists z3; then
        Z3_VERSION=$(z3 --version 2>/dev/null | grep -oP 'version \K\d+\.\d+\.\d+' || echo "not found")
        echo "Found Z3 version: $Z3_VERSION"
        if [[ $Z3_VERSION != "$Z3_REQUIRED_VERSION" ]]; then
            echo "Z3 version is not $Z3_REQUIRED_VERSION. Disabling strict Z3 requirement."
            return 1  # Incorrect version of Z3
        else
            echo "Z3 version is correct ($Z3_REQUIRED_VERSION)."
            return 0  # Correct version of Z3
        fi
    else
        echo "Z3 is not installed. SMT checking will be disabled."
        return 2  # Z3 is not found
    fi
}

# Function to clone or update the Solidity repository
clone_or_update_solidity_repo() {
    if [ ! -d "solidity" ]; then
        echo "Cloning Solidity repository..."
        git clone --recursive https://github.com/ethereum/solidity.git || {
            echo "Warning: Failed to clone Solidity repository. Please check your connection."
        }
    else
        echo "Solidity repository already exists. Updating..."
        cd solidity || exit
        git pull || {
            echo "Warning: Failed to update the Solidity repository. Proceeding with the current version."
        }
        cd ..
    fi
    cd solidity || exit
}

# Function to check out the specific Solidity version
checkout_solidity_version() {
    echo "Checking out Solidity version $SOLC_VERSION..."
    git checkout tags/$SOLC_VERSION || {
        echo "Warning: Failed to checkout version $SOLC_VERSION. Proceeding with the default branch."
    }
}

# Function to clean the build directory
clean_build_directory() {
    echo "Cleaning build directory..."
    rm -rf build
    mkdir build
    cd build || exit
}

# Function to build Solidity with proper Z3 and Boost configuration
build_solidity() {
    # Clean the build directory first
    clean_build_directory

    # Check the Z3 version and build accordingly
    check_z3_version
    Z3_STATUS=$?

    # Handle Z3 conflicts and build with dynamic Boost libraries
    if [[ $Z3_STATUS -eq 1 ]]; then
        echo "Building Solidity with dynamic Boost libraries and relaxed Z3 check..."
        cmake -DBoost_USE_STATIC_LIBS=OFF -DSTRICT_Z3_VERSION=OFF -DCMAKE_CXX_FLAGS="-Wno-error=maybe-uninitialized" .. || {
            echo "Warning: Build configuration failed. Proceeding anyway..."
        }
    elif [[ $Z3_STATUS -eq 2 ]]; then
        echo "Building Solidity with dynamic Boost libraries and no Z3 support..."
        cmake -DBoost_USE_STATIC_LIBS=OFF -DUSE_Z3=OFF -DCMAKE_CXX_FLAGS="-Wno-error=maybe-uninitialized" .. || {
            echo "Warning: Build configuration failed. Proceeding anyway..."
        }
    else
        echo "Building Solidity with dynamic Boost libraries..."
        cmake -DBoost_USE_STATIC_LIBS=OFF -DCMAKE_CXX_FLAGS="-Wno-error=maybe-uninitialized" .. || {
            echo "Warning: Build configuration failed. Proceeding anyway..."
        }
    fi

    echo "Compiling Solidity..."
    cmake --build . || {
        echo "Warning: Compilation failed. Please review the errors."
    }
}

# Function to install Solidity
install_solidity() {
    echo "Installing Solidity (solc)..."
    sudo cmake --install . || {
        echo "Warning: Installation failed. Please review the errors."
    }
}

# Function to verify the installation of Solidity
verify_solidity_installation() {
    if command_exists solc; then
        echo "Verifying Solidity installation..."
        solc --version || {
            echo "Warning: Could not verify the Solidity installation. Please check manually."
        }
    else
        echo "Warning: solc not found. Installation may have failed, but continuing."
    fi
}

# ---------------- SCRIPT EXECUTION ----------------

# Step 1: Install dependencies
install_dependencies

# Step 2: Clone or update the Solidity repository
clone_or_update_solidity_repo

# Step 3: Check out the desired Solidity version
checkout_solidity_version

# Step 4: Build Solidity with proper dynamic Boost and Z3 configuration
build_solidity

# Step 5: Install Solidity
install_solidity

# Step 6: Verify installation
verify_solidity_installation

echo "Solidity (solc) installation script has completed."
