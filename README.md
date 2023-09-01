# NEOVIM

[ubuntuにインストール](https://github.com/neovim/neovim/wiki/Installing-Neovim#linux)

👇~/.bashrc
```sh
alias nv='${ssd}/appimage/nvim.appimage' 
```

neovimのバージョンチェック
```sh
nvim --version
```

```sh
sudo apt update -y && sudo apt upgrade -y
[[ -z $(which curl) ]] && sudo apt install curl -y
[[ -z $(which git) ]] && sudo apt install git -y
[[ -z $(which fdfind) ]] && sudo apt install fd-find -y && ln -s $(which fdfind) "~/.local/bin/fd"
[[ -z $(which rg) ]] && sudo apt install ripgrep -y
```

```sh
pip3 install pynvim
```

## node.js のインストール

node.jsは Mason ~~coc.nvim~~ を使うのに必要。
node.js version: `node --version` 

windowsだと普通にダウンロードして、インストールで大丈夫。
ubuntuの場合は、`sudo apt install nodejs' だと、バージョンが古い。
なので、インストール後に'nvm'を使って、アップグレードする

👇.bashrcに追加

[nvm](https://github.com/nvm-sh/nvm)

```sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
nvm install node
```


