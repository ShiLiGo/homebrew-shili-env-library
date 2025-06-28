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
    
    #进入到Debug程序目录
    顶部菜单栏->Product->Show Build Folder in Finder->进入 ./Products/Debug

    #拷贝C++程序配置到执行目录
    cd /path/to/your/project/root/
    find . -name '*.conf' -type f ! -name '*redis*' -exec cp {} /path/to/your/Debug/ \;

    #生成C++程序统一启动脚本
    cd /path/to/your/Debug/
    ls | grep -v conf | grep -v log | grep -v nohup  | awk '{print "nohup","./"$1,"&"}' | tee -a start.sh

    #Xcode启动C++程序时可能会遇到的问题
    1、Call luaL_dofile is failed(ErrInfo=cannot open /Users/lishi/Library/Developer/Xcode/DerivedData/gjservice-efvdxormtnrwhwanrmlwlfdabdae/Build/Products/Debug/gjfkldteamarbiter.conf: No such file or directory, file = /Users/lishi/Library/Developer/Xcode/DerivedData/gjservice-efvdxormtnrwhwanrmlwlfdabdae/Build/Products/Debug/gjfkldteamarbiter.conf) in CLuaIni::LoadFile()
    解决方案：拷贝缺少的配置文件和目录到 Debug 目录下
    2、M 系列芯片运行 C++程序 Build Failed
    解决方案：todo
    3、Xcode16.4 Constant expression evaluates to -2 which cannot be narrowed to type 'const unsigned int'
    解决方案：业务上做调整，不使用负数code

### homebrew

    #homebrew 默认工作目录 /usr/local
    本机环境的 uwsgi、nginx 的工作目录和日志目录都在 Linux 目录的基础上加上 /usr/local

    # C++程序依赖库
    brew install lua libevent hiredis log4cplus boost hiredis jsoncpp ossp-uuid openssl curl 
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

    #nginx 默认工作目录
    /usr/local/etc/nginx
    #启动 nginx 服务
    brew services start nginx
    #uwsgi 默认工作目录
    /usr/local/etc/uwsgi/apps-enabled/
    #启动 uwsgi 服务
    brew service start uwsgi

### VSCode
    
    #Python项目设置终端默认进入虚拟环境
    1、右下角选择 Python 版本
    2、输入解释器路径
    3、输入 /usr/local/var/www/python-venvs/my-env/bin/python

    #Python项目配置调试启动
    1、左侧侧边栏-运行和调试
    2、创建 launch.json 文件
    3、选择调试器-Python Debugger 调试配置-带有参数的 Python 文件
    4、配置模板
    {
        // 使用 IntelliSense 了解相关属性。 
        // 悬停以查看现有属性的描述。
        // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Python 调试程序: 包含参数的当前文件",
                "type": "debugpy",
                "request": "launch",
                "program": "${workspaceFolder}/webpy_zjmj.py", #web程序入口
                "console": "integratedTerminal",
                "args": "8081", #监听端口号
                "justMyCode": false, #是否只调试业务代码，设置成false可以调试系统模块的代码
            }
        ]
    }
    5、运行-启动调试（断点调试）、以非调试模式运行（前台启动）

    #Python项目配置调试启动可能会碰到的问题
    1、ImportError: cannot import name 'Mapping' from 'collections' (/usr/local/Cellar/python@3.10/3.10.18/Frameworks/Python.framework/Versions/3.10/lib/python3.10/collections/__init__.py)
    解决方案: pip install --upgrade PyJWT
    
### sequel ace
    
    #远端MySQL数据导出
    1、打开sequel ace
    2、通过SSH连接数据库
    3、File->Export->自定义文件名 duole.sql.gz，Table 的表选项中，S、C 都全选（如果想要一个全新的数据库，C不要选，C的意思是content）->export

### Docker-Desktop

    #修改镜像地址
    设置-Docker Engine-如有覆盖，无则添加配置-Apply&restart
    "registry-mirrors": [
        "https://docker.xuanyuan.me"
    ]

    #启动本地 MySQL 和 Redis 数据库
    1、下载最新的 redis 文件备份（rdb 文件）
    2、拉取 redis 镜像
    docker pull redis:latest
    3、启动本地 redis 服务
    docker run --name my-redis-container \
        -v /path/to/your/rdb/file/:/data \
        -p 6379:6379 \
        -d redis:latest
    4、拉取 MySQL 镜像
    docker pull circleci/mysql:5.7.36
    5、启动本地 Mysql 服务
    docker run --name my-mysql-container \
        -e MYSQL_ROOT_PASSWORD=123456 \
        -e MYSQL_PASSWORD=123456 \
        -e MYSQL_USER=duoletest \
        -e MYSQL_DATABASE=test_zhuoji \
        -v /path/to/your/sql.gz/file/duole.sql.gz:/docker-entrypoint-initdb.d/duole.sql.gz \
        -p 3306:3306 \
        -d circleci/mysql:5.7.36