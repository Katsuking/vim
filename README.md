### はじめに

もうほぼ思想みたいなもんですが、個人的にVScodeで作業をする言語とneovimを使う言語で別れています。
vscode:
        js等のweb系
        remote developmentでサーバーのファイルをいじるとき
neovim:
        Compiled 言語
        shell

neovimは、なんといっても検索やキーバインドが便利で作業自体は圧倒的に短縮できると思います。

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
[[ -z $(which fdfind) ]] && sudo apt install fd-find -y && ln -s $(which fdfind) ~/.local/bin/fd
[[ -z $(which rg) ]] && sudo apt install ripgrep -y
```

# add "export PATH=$PATH:'~/.local/bin'" to ~/.bash_aliases

```sh
pip3 install pynvim
```

## node.js のインストール

node.jsは 自動補完 ~~coc.nvim~~ を使うのに必要。
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

### おまけ

いきなりですが、fzf(fuzzy finder)と組み合わせるとさらに強力なので
個人的に用意しているエイリアスの紹介

```sh
alias nv='${ssd}/appimage/nvim.appimage' 

function nf() {
        # change dir + open file with neovim
        local cmdarg=${1}
        [[ -z ${cmdarg} ]] && local fp=$(find . -type f | fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down)

        [[ -n ${cmdarg} ]]  && cd $(dirname ${cmdarg}) 2>/dev/null && nv "${cmdarg}"

        if [[ -n ${fp} ]];then
                cd $(dirname "${fp}")
                [[ $(ls | grep venv) == "venv" ]] && source 'venv/bin/activate'
                nv $(basename "${fp}" 2>/dev/null)
        fi

        # init.luaを編集した場合は、git管理ディレクトリへ飛ばす
        if [[ $(basename ${fp} 2>/dev/null ) == "init.lua" ]]; then
                cp -rp ~/.config/nvim/* "${dev}/vim"
        fi
}

alias nf=nf
```


