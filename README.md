

官网：https://aria2.github.io/

## 安装aria2

``` bash
sudo apt-get install aria2
```

查看版本：
```
aria2c -v                    
aria2 版本 1.35.0
Copyright (C) 2006, 2019 Tatsuhiro Tsujikawa
```

## 运行

### 直接下载任务

``` bash
## 直接从网上下载
aria2c http://example.org/mylinux.iso

## 从两个源下载
aria2c http://a/f.iso ftp://b/f.iso

## 四线程同时下载
aria2c -j4 http://a/f.iso

## 按顺序下载文件中的链接
aria2c -i uris.txt
```

### RPC方式（命令行启动服务）

本方式需要配置RPC参数，配置文件一般是aria2.conf。

配置文件下载：

需要将配置文件里的下载路径修改下，默认是`/tmp`：
``` bash
sed -i "s#/tmp#${HOME}/下载#g" aria2.conf 
```

下载后放到：`/etc/aria2/`:

``` bash
sudo mkdir /etc/aria2/
sudo touch /etc/aria2/aria2.session

sudo cp aria2.conf /etc/aria2/aria2.conf
```

手动启动RPC服务：

``` bash
aria2c --conf-path=aria2.conf
```
此时aria2c就会监听本地端口6800。

`--conf-path` 指定配置文件路径，`-D` 以Daemon的方式启动。

我们先来添加个下载任务：
``` bash
curl -s http://localhost:6800/jsonrpc -H "Content-Type: application/json" -H "Accept: application/json" --data '{"jsonrpc": "2.0","id":1, "method": "aria2.addUri", "params":[["https://cdn.jsdelivr.net/gh/XIU2/TrackersListCollection/best.txt"]]}'
```

> 这里先使用命令行方式调用，后面章节会介绍如何基于web-ui添加任务。

### RPC方式（作为服务启动）

创建`aria2.service`：
``` bash
echo "[Unit]
Description=Aria2c download manager
Requires=network.target
After=dhcpcd.service
    
[Service]
Type=forking
User=root
RemainAfterExit=yes
ExecStart=/usr/bin/aria2c --conf-path=/etc/aria2/aria2.conf --daemon
ExecReload=/usr/bin/kill -HUP $MAINPID
RestartSec=1min
Restart=on-failure
    
[Install]
WantedBy=multi-user.target" > aria2.service
```

注意，需要将配置里的`User=root`改成实际用户名:
``` bash
sed -i "s#User=root#User=${USER}#g" aria2.service
```

安装服务:
``` bash
sudo cp aria2.service /etc/systemd/system/aria2.service
```

启用并启动服务：
``` bash
systemctl enable aria2 
systemctl start aria2
```


## 安装AriaNg管理面板

AriaNg是一个前端(HTML+JS静态)控制面板，是aria2的web-ui。通过这个面板，我们可以在页面手动添加任务。

Github项目：https://github.com/mayswind/AriaNg
下载地址：https://github.com/mayswind/AriaNg/releases/latest

下载AriaNg-1.2.3-AllInOne.zip：
```
https://github.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3-AllInOne.zip
```


解压其实就是个html文件。一般Ubuntu都安装有apache，所以将html文档扔到本地的`/var/html/aria/`下面，浏览器访问`http://localhost/aria.html`即可。


## 安装aria2浏览器扩展插件

插件名称：添加到aria2
插件地址：https://chrome.google.com/webstore/detail/%E6%B7%BB%E5%8A%A0%E5%88%B0aria2/nimeojfecmndgolmlmjghjmbpdkhhogl/related?hl=zh-CN

后续就可以使用aria2接替浏览器的下载功能。


