#!/bin/bash

echo "🚀 Setting up LaTeX Viewer..."

# Ensure script is run with sudo permissions (only for Mac/Linux)
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run this script with sudo: sudo ./install.sh"
    exit 1
fi

# Install Homebrew if not installed (Mac Only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

# Install Python3 and Pip (Linux/Mac)
echo "🐍 Installing Python & Pip..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install python3
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install -y python3 python3-pip
fi

# Create Virtual Environment
echo "📦 Setting up Python Virtual Environment..."
python3 -m venv venv
source venv/bin/activate

# Install Required Python Packages
echo "📦 Installing Python Dependencies..."
pip install --upgrade pip
pip install flask watchdog

# Install LaTeX (Mac/Linux)
echo "📄 Installing LaTeX..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install --cask mactex
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt install -y texlive-full
fi

# Verify LaTeX Installation
if ! command -v pdflatex &> /dev/null; then
    echo "⚠️  LaTeX installation failed. Please check manually."
    exit 1
else
    echo "✅ LaTeX installed successfully."
fi

# Compile Sample LaTeX File
echo "📄 Compiling sample LaTeX file..."
pdflatex -output-directory static yourfile.tex

# Start Flask Server
echo "🚀 Running LaTeX Viewer..."
python main.py
