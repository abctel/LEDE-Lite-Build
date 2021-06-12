# 固件介绍

本固件订制原则是功能最小化，稳定运行为主，尤其适合作为单网口旁路有，虚拟机旁路有运行使用，同时也可作为对7x24稳定运行的朋友使用。

- 固件仅在原版lede基础上精简、添加日常常用到插件：

1. passwall       （翻墙）
2. AdGuardHome     (广告过滤)
3. SmartDNS       （DNS加速）
4. 微信推送姬      （运行状态通知）
5. 动态DNS        （IP绑定）
6. 网络唤醒       （内网设备启动）
7. KMS服务器      （内网windows家族软件激活）
8. TTYD终端       （超级方便的web ssh)

- 使用的主题：

1. opentomcat

## 插件源

为保证固件的绝对安全，本固件只使用lean's作者、社区高度认可插件包、源头作者开源的插件.

- kenzok8的插件包

1. <https://github.com/kenzok8/openwrt-packages>
2. <https://github.com/kenzok8/small>

- esirplayground的关机插件

1. <https://github.com/esirplayground/luci-app-poweroff>

## 更新说明

- 2021/06/12

 1. 第一补全说明,懒得写啦,功能就那几个而已.
 2. 下次一定


## 已知问题

- AdGuardHome 无法更新核心,重复提示:A task is already running.

  解决方法:

1. 确认路由器是否联网成功.
  通过 网络 -> 网络诊断 -> NSLOOKUP 按钮是否能够获取到openwrt.org的解析地址判断.

2. 多次点击更新按钮依然出现 A task is already running. 是因为部分机型在代码中 check_if_already_running 检测机制被卡住造成.

> 只需通过TTYD终端插件通过以下方式即可:
>
>  1. 命令 cd /usr/share/AdGuardHome
>  2. 命令 vi update_core.sh
>  3. 按键盘i键进入编译模式
>  4. 将以下代码注意掉(注释方法为行首添加#)
>  注释掉内容页最上方的check_if_already_running函数

  ```shell
  #!/bin/bash
  PATH="/usr/sbin:/usr/bin:/sbin:/bin"
  binpath=$(uci get AdGuardHome.AdGuardHome.binpath)
  if [ -z "$binpath" ]; then
  uci set AdGuardHome.AdGuardHome.binpath="/tmp/AdGuardHome/AdGuardHome"
  binpath="/tmp/AdGuardHome/AdGuardHome"
  fi
  mkdir -p ${binpath%/*}
  upxflag=$(uci get AdGuardHome.AdGuardHome.upxflag 2>/dev/null)

  #check_if_already_running(){
   #        running_tasks="$(ps |grep "AdGuardHome" |grep "update_core" |grep -v "grep" |awk '{print $1}' |wc -l)"
   #        [ "${running_tasks}" -gt "2" ] && echo -e "\nA task is already running."  && EXIT 2
  #}

  check_wgetcurl(){
        which curl && downloader="curl -L -k --retry 2 --connect-timeout 20 -o" && return
        which wget && downloader="wget --no-check-certificate -t 2 -T 20 -O" && return
        [ -z "$1" ] && opkg update || (echo error opkg && EXIT 1)
        [ -z "$1" ] && (opkg remove wget wget-nossl --force-depends ; opkg install wget ; check_wgetcurl 1 ;return)
        [ "$1" == "1" ] && (opkg install curl ; check_wgetcurl 2 ; return)
        echo error curl and wget && EXIT 1
  }
  ```

> 注释掉内容页最下方Main函数中的check_if_already_running即可

  ```shell
  main(){  
        #check_if_already_running                                       
        check_latest_version
        $1
  }
  ```

## 鸣谢

感谢以下开源作者的开源项目以及详尽的文档,排名不分先后.

[P3TERX](https://github.com/P3TERX)

[coolsnowwolf](https://github.com/coolsnowwolf)

[kenzok8](https://github.com/kenzok8)

[Nick Peng](https://github.com/pymumu)

[tty228](https://github.com/tty228)

[Harry Gabriel](https://github.com/ozon)
