# Dotfiles

> managed by [chezmoi](https://www.chezmoi.io)

## New machine

To get started run the following:

`curl https://raw.githubusercontent.com/danielmichaels/dotfiles/main/setup.sh | bash`

This will install `rtx` and then drop `chezmoi` onto the machine.

From there you'll need to run the base installer which will setup the minimum packages required
for ubuntu.

`bash $HOME/.local/share/boostrap-ubuntu.sh`
