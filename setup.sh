NC='\033[0m' # No Color
TICK="✅${NC}"
PROGRESS="⏳${NC}"
CROSS="❌${NC}"

# MacOS System
# Remove Message of the day prompt
touch $HOME/.hushlogin
# Show hidden files in finder
defaults write com.apple.finder AppleShowAllFiles YES
# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install iTerm2
brew install --cask iterm2

echo "${PROGRESS} Installing GIT..."
if OUTPUT=$(brew install git 2>&1); then
  echo "${TICK} GIT installed"
else
  echo "${CROSS} Error during GIT installation. Error:\n"
  echo "$OUTPUT"
  exit 1
fi

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "${PROGRESS} Removing default .zshrc..."
rm "$HOME/.zshrc"
echo "${TICK} Default .zshrc removed"

echo "${PROGRESS} Installing cURL..."
stow curl -t $HOME/
echo "${TICK} cURL installed"

echo "${PROGRESS} Installing zsh..."
stow --adopt zsh -t $HOME/
echo "${TICK} zsh installed"

# ZSH theme
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
# ZSH autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# ZSH syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# ZSH git-open plugin
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
# ZSH fonts
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o ~/Library/Fonts/MesloLGS-NF-Regular.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o ~/Library/Fonts/MesloLGS-NF-Bold.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o ~/Library/Fonts/MesloLGS-NF-Italic.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o ~/Library/Fonts/MesloLGS-NF-Bold-Italic.ttf
# ZSH copy default profile
cp "$HOME/dotfiles/zsh/Profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
sleep 1

echo "Set profile GUID"
echo "Extracting profile GUID"
GUID=$(grep -oE '"Guid"\s*:\s*"([^"]+)"' "$HOME/dotfiles/zsh/Profiles.json" | cut -d'"' -f4)
echo "Extracted profile GUID: ${GUID}"
echo "Storing default bookmark guid"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$GUID"
echo "Stored default bookmark guid"

# Git
stow git -t $HOME/

# Restart shell
killall cfprefsd