# homebrew-shili-env-library

Mac 本地开发环境安装教程

1、安装Homwbrew

    # 下载安装脚本
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > homebrew-install.sh
    # 切换安装包源，加速下载
    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.bash_profile
    echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> ~/.bash_profile
    echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> ~/.bash_profile
    echo 'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"' >> ～/.bash_profile
    source ~/.bash_profile
    # 执行安装脚本
    bash homebrew-install.sh

2、安装 VSCODE

    brew install --cask visual-studio-code

3、安装 Xcode，App Store搜索 Xcode

4、安装 Docker-Desktop

    brew install --cask docker-desktop

5、安装sequel ace

    brew install --cask sequel-ace
