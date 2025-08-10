#!/bin/bash

# URL of the fonts.conf file from the GitHub repository
FONTS_CONF_URL="https://raw.githubusercontent.com/r-not/MyLinuxConfFiles/master/Debian/Debian-10/fonts.conf"
# Target directory for fonts.conf
CONFIG_DIR="$HOME/.config/fontconfig"
# Target file path for fonts.conf
CONFIG_FILE="$CONFIG_DIR/fonts.conf"
# Backup file path with timestamp for fonts.conf
BACKUP_FILE="$CONFIG_DIR/fonts.conf.bak.$(date +%Y%m%d_%H%M%S)"

# URL of the kalpurush.ttf font file from GitHub
FONT_URL="https://github.com/r-not/unibnfonts/raw/refs/heads/master/omicronlab-fonts/kalpurush.ttf"
# Target directory for fonts
FONTS_DIR="$HOME/.local/share/fonts"
# Target file path for kalpurush.ttf
FONT_FILE="$FONTS_DIR/kalpurush.ttf"

echo
echo "🚀 Starting system-wide sparkle Bangla font setup process...."

# Check and create .local/share/fonts directory if it doesn't exist
echo
if [ -d "$FONTS_DIR" ]; then
    echo "✅ Fonts directory already exists at $FONTS_DIR"
else
    echo "📁 Creating new fonts directory at $FONTS_DIR"
    mkdir -p "$FONTS_DIR"
fi

# Check if kalpurush.ttf already exists
if [ -f "$FONT_FILE" ]; then
    echo
    echo "⚠️ Existing Kalpurush font found at $FONTS_DIR"
    echo
    echo "🤔 Do you want to keep the existing font or install the new one?"
    echo "  Type '1' to keep the old font or '2' to replace it:"
    read -r user_choice
    if [ "$user_choice" = "1" ]; then
        echo
        echo "👌 Keeping the existing Kalpurush font."
        echo
	exit 0
    elif [ "$user_choice" != "2" ]; then
        echo
        echo "❌ Invalid choice. Please run the script again and choose 'keep' or 'install'."
        exit 1
    fi
fi

# Download the kalpurush.ttf file from GitHub
echo
echo "🌐 Downloading kalpurush.ttf from GitHub..."
if curl -L -o "$FONT_FILE" "$FONT_URL"; then
    echo
    echo "🎉 Success! The Kalpurush font has been downloaded to $FONTS_DIR"
else
    echo
    echo "❌ Error: Failed to download Kalpurush font"
    exit 1
fi

# Verify the kalpurush.ttf file was downloaded
if [ -f "$FONT_FILE" ]; then
    echo
    echo "✔️ File verified: Kalpurush font is ready to roll!"
else
    echo
    echo "❌ Error: File verification failed!!"
    exit 1
fi


# Check and create .config/fontconfig directory if it doesn't exist
echo
if [ -d "$CONFIG_DIR" ]; then
    echo "✅ fontconfig directory already exists at $CONFIG_DIR"
else
    echo "📁 Creating new fontconfig directory at $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

# Check if fonts.conf already exists and back it up
if [ -f "$CONFIG_FILE" ]; then
    echo
    echo "⚠️ Existing fonts.conf found! Backing it up to $BACKUP_FILE"
    mv "$CONFIG_FILE" "$BACKUP_FILE"
    echo
    echo "🔄 Backup created successfully"
fi

# Download the fonts.conf file from GitHub
echo
echo "🌐 Downloading fonts.conf from GitHub..."
if curl -o "$CONFIG_FILE" "$FONTS_CONF_URL"; then
    echo
    echo "🎉 Success! fonts.conf has been downloaded to $CONFIG_DIR"
else
    echo
    echo "❌ Error: Failed to download fonts.conf"
    exit 1
fi

# Verify the fonts.conf file was downloaded
if [ -f "$CONFIG_FILE" ]; then
    echo
    echo "✔️ File verified: fonts.conf is in place"
else
    echo
    echo "❌ Error: File verification failed for fonts.conf"
    exit 1
fi
echo
echo "🏁 All done! System-wide sparkle Bangla font setup is complete."
