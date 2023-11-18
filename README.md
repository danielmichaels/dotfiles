# Dotfiles

> managed by [chezmoi](https://www.chezmoi.io)

## New machine

To get started run the following:

`curl https://raw.githubusercontent.com/danielmichaels/dotfiles/main/setup.sh | bash`

This will install `rtx` and then drop `chezmoi` onto the machine.

From there you'll need to run the base installer which will setup the minimum packages required
for ubuntu.

Until this is done expect some components to be slightly broken. The boostrapping
will install packages required for the system to function correctly.

```shell
bash $HOME/.local/share/chezmoi/setup/bootstrap-ubuntu.sh
# consider changing the default shell to zsh
chsh -s zsh
```
