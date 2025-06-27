# homebrew-shili-env-library

# Mac 本地开发环境安装教程

## 1.基础软件安装

### Xcode
    App Store 搜索 Xcode

### homebrew
    #切换终端环境至x86
    arch -x86_64 zsh
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

### VSCode

    brew install --cask visual-studio-code

### sequel ace

    brew install --cask sequel-ace

### Docker-Desktop

    brew install --cask docker-desktop


## 2. 软件环境配置

### Xcode
    todo

### homebrew

    # C++程序依赖库
    brew install lua libevent hiredis log4cplus hiredis jsoncpp ossp-uuid openssl curl 
    brew tap shiligo/shili-env-library/mysql-client@5.7
    brew install shiligo/shili-env-library/mysql-client@5.7
    brew install shiligo/shili-env-library/mysql-client@250
    # Python程序依赖库
    brew install python@3.10 
    brew install shiligo/shili-env-library/uwsgi 
    brew install shiligo/shili-env-library/nginx
    # 创建 Python 虚拟环境
    mkdir -p /usr/local/var/www/python-venvs && cd /usr/local/var/www/python-venvs
    python3 -m venv my-env
    source my-env/bin/activate
    pip install -r my-requirement.txt
    #启动 nginx 服务
    brew services start nginx
    #启动 uwsgi 服务
    brew service start uwsgi

### VSCode
    #Python项目设置终端默认进入虚拟环境
    右下角选择 Python 版本-输入解释器路径-粘贴/usr/local/var/www/python-venvs/my-env/bin/python

### sequel ace

    #1、打开sequel ace
    #2、通过SSH连接数据库
    #3、File->Export->自定义文件名 duole.sql.gz，Table 的表选项中，S、C 都全选（如果想要一个全新的数据库，C不要选，C的意思是content）->export

### Docker-Desktop

    #修改镜像地址
    设置-Docker Engine-如有覆盖，无则添加配置-Apply&restart
    "registry-mirrors": [
        "https://docker.xuanyuan.me"
    ]
    #1、下载最新的 redis 文件备份（rdb 文件）
    #2、拉取 redis 镜像
    docker pull redis:latest
    #3、启动本地 redis 服务
    docker run --name my-redis-container -v /path/to/your/rdb/file/:/data -p 6379:6379 -d redis:latest
    #4、拉取 MySQL 镜像
    docker pull circleci/mysql:5.7.36
    #5、启动本地 Mysql 服务
    docker run --name my-mysql-container -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_PASSWORD=123456 -e MYSQL_USER=duoletest -e MYSQL_DATABASE=test_zhuoji -v /path/to/your/sql.gz/file/duole.sql.gz:/docker-entrypoint-initdb.d/duole.sql.gz -p 3306:3306 -d circleci/mysql:5.7.36