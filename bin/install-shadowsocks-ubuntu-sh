# 参考https://teddysun.com/392.html
# 客户端下载：
# https://github.com/shadowsocks/shadowsocks-windows/releases
#使用方法, 使用root用户登录，运行以下命令：安装完成后，已将 shadowsocks-go 加入开机自启动。
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-go.sh
chmod +x shadowsocks-go.sh
./shadowsocks-go.sh 2>&1 | tee shadowsocks-go.log
# 客户端配置的参考链接：https://teddysun.com/339.html
# root 命令：./shadowsocks-go.sh uninstall
/etc/init.d/shadowsocks status # 可以查看 shadowsocks-go 进程是否已经启动。
