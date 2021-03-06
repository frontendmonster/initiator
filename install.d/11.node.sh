#!/bin/bash
. "$(dirname "$BASH_SOURCE")/../utils.sh"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

VERSION="v0.37.2"

if ! exists nvm; then
  title "Installing NVM"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh | bash

  grep -q -F '# Export nvm and load NVM' "$HOME/.profile"

  if [ $? -ne 0 ]; then
    title "Setup NVM"
    {
      echo -e '\n# Export nvm and load NVM'
      echo -e "if [ -d $HOME/.nvm ]; then"
      echo -e "  export NVM_DIR=\"$HOME/.nvm\""
      echo -e "fi"
    } >>"$HOME/.profile"
  fi

  . "$HOME/.profile"

  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  nvm install node
  nvm install --lts --latest-npm
fi

title "Installing NPM/Yarn Global Packages"

packages=(
  eslint
  fx
)

for package in "${packages[@]}"; do
  package_name=$(echo "$package" | awk '{print $1}')
  if test "$(which "$package_name" 2>/dev/null)"; then
    warn "$package_name already installed..."
  else
    progress "Installing $package_name"
    yarn global add "$package"
  fi
done

progress "Done"
