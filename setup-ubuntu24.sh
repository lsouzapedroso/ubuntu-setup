#!/bin/bash

# Atualizando o sistema
echo "🔄 Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instalando dependências básicas
echo "📦 Instalando dependências básicas..."
sudo apt install -y curl wget git gnome-software gnome-software-plugin-flatpak software-properties-common apt-transport-https ca-certificates gnupg lsb-release

# ---------------------
# JetBrains Toolbox
# ---------------------
echo "💻 Instalando JetBrains Toolbox..."
TOOLBOX_VERSION=$(curl -s https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release | grep -Po '"version":"\K[^"]+')
TOOLBOX_URL=$(curl -s https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release | grep -Po '"linux":{"link":"\K[^"]+')
wget -O toolbox.tar.gz "$TOOLBOX_URL"
mkdir -p ~/.local/share/JetBrains/Toolbox
tar -xzf toolbox.tar.gz -C ~/.local/share/JetBrains/Toolbox --strip-components=1
~/.local/share/JetBrains/Toolbox/jetbrains-toolbox &

# ---------------------
# Docker + Docker Compose
# ---------------------
echo "🐳 Instalando Docker e Docker Compose..."
sudo apt remove docker docker-engine docker.io containerd runc -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ativando Docker sem sudo
sudo usermod -aG docker $USER

# ---------------------
# Brave Browser
# ---------------------
echo "🦁 Instalando Brave Browser..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave.com/signing-keys/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
  https://brave-browser-apt-release.s3.brave.com/ stable main" | \
  sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null

sudo apt update
sudo apt install -y brave-browser

# ---------------------
# Spotify via Snap
# ---------------------
echo "🎵 Instalando Spotify..."
sudo snap install spotify

# ---------------------
# Flatpak
# ---------------------
echo "📦 Instalando Flatpak..."
sudo apt install -y flatpak

# Adicionando repositório Flathub
echo "🔗 Adicionando Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Finalização
echo "✅ Instalação concluída!"
echo "🔁 Reinicie ou deslogue para aplicar permissões do Docker."

