#!/bin/bash

# Function to check if a directory is in PATH
is_in_path() {
    case ":$PATH:" in
        *":$1:"*) return 0;;
        *) return 1;;
    esac
}

# Function to get the user's shell configuration file
get_shell_config() {
    case "$SHELL" in
        */bash) echo "$HOME/.bashrc";;
        */zsh) echo "$HOME/.zshrc";;
        */fish) echo "$HOME/.config/fish/config.fish";;
        *) echo "";;
    esac
}

# Download the get script
echo "Downloading get script..."
curl -s -o /tmp/get https://raw.githubusercontent.com/MohamedElashri/get/refs/heads/main/get

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the get script. Please check your internet connection and try again."
    exit 1
fi

# Make the script executable
chmod +x /tmp/get

# Ask user for installation preference
read -p "Do you want to install get system-wide (requires sudo) or locally? [system/local] (default: local): " install_type

# Set default to local if no input is provided
install_type=${install_type:-local}

if [ "$install_type" = "system" ]; then
    # System-wide installation
    echo "Installing get to /usr/local/bin/..."
    if sudo mv /tmp/get /usr/local/bin/; then
        echo "get has been successfully installed to /usr/local/bin/"
        install_path="/usr/local/bin"
    else
        echo "Error: Failed to install get system-wide. Falling back to local installation."
        install_type="local"
    fi
fi

if [ "$install_type" = "local" ]; then
    # Local installation
    mkdir -p "$HOME/.local/bin"
    if [ -f /tmp/get ]; then
        mv /tmp/get "$HOME/.local/bin/"
        echo "get has been successfully installed to $HOME/.local/bin/"
        install_path="$HOME/.local/bin"
    else
        echo "Error: Installation file not found. Installation failed."
        exit 1
    fi
elif [ "$install_type" != "system" ]; then
    echo "Invalid input. Assuming local installation."
    mkdir -p "$HOME/.local/bin"
    if [ -f /tmp/get ]; then
        mv /tmp/get "$HOME/.local/bin/"
        echo "get has been successfully installed to $HOME/.local/bin/"
        install_path="$HOME/.local/bin"
    else
        echo "Error: Installation file not found. Installation failed."
        exit 1
    fi
fi

# Check if installation path is in PATH
if ! is_in_path "$install_path"; then
    echo "Warning: $install_path is not in your PATH."
    
    # Get the appropriate shell configuration file
    config_file=$(get_shell_config)
    
    if [ -n "$config_file" ]; then
        echo "To add it to your PATH, run the following command:"
        echo "echo 'export PATH=\"$install_path:\$PATH\"' >> $config_file"
        echo "Then, restart your terminal or run 'source $config_file'"
    else
        echo "We couldn't determine your shell configuration file."
        echo "Please add $install_path to your PATH manually."
    fi
fi

echo "Installation complete. You can now use 'get' command."
