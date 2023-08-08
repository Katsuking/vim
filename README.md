# NEOVIM

[ubuntuにインストール](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)

add-apt-repository使わないと、古いバージョンをインストールするため
下記の手順で実施

```sh
sudo apt update -y && sudo apt upgrade -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update -y
sudo apt-get install neovim -y
nvim --version # 7以上であることを確認
```

エイリアス用意してもいいと思う
👇.bashrc
```sh
alias nv='nvim'
```

各種設定:`/home/im-outie/.config/nvim`

他にもたくさんあるっぽいけど、自分が使っているプラグインマネジャー
[vim-plug](https://github.com/junegunn/vim-plug)

**基本的にsh -c curlってコマンドは理解せずに使ったらアカン**

neovimの場合
```sh
sudo apt update -y && sudo apt upgrade -y
[[ -z $(which curl) ]] && sudo apt install curl -y
[[ -z $(which git) ]] && sudo apt install git -y

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

```sh
pip3 install pynvim
```

## node.js のインストール

node.jsはcoc.nvimを使うのに必要。
node.js version: `node --version` 

windowsだと普通にダウンロードして、インストールで大丈夫。
ubuntuの場合は、`sudo apt install nodejs' だと、バージョンが古い。
ので、インストール後に'nvm'を使って、アップグレードする

👇.bashrcに追加
```sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```
`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash'


## LSP ( Language Server Protocol)

(LSP plugins)[https://github.com/rockerBOO/awesome-neovim#lsp]
めちゃくちゃたくさんあるけど、使うのは
https://github.com/neoclide/coc.nvim


## その他の設定

(coc.nvim)[https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim]

(coc lang support)[https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions]

e.g. インストール済み
`cd /home/im-outie/.config/coc/extensions/node_modules`
```

:CocInstall coc-css coc-docker coc-html coc-json coc-pyright coc-sh coc-tsserver coc-yaml

正常にcoc.nvimが動いているか確認
`:checkhealth`


:
