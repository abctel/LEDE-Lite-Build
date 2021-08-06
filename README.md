# 近期请暂勿更新，大版本调整中，将引入全面防污染功能、dnsmasq -> AdGuardHome -> SmartDNS -> PassWall -> Client的数据运行流程及整套开机即用的配置文件。

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
9. JD签到插件      （挂豆，获取cookies超方便）

- 重要提醒

我的固件主要目的是满足翻墙->域名加速、防劫持->广告过滤，所以插件的设置存在设置逻辑，错误的修改和关闭、启用关联的插件会造成无法通过域名的访问，插件的逻辑为passwall（提供翻墙服务，是否启用不会造成无法访问域名的情况）-> AdGuardHome(提供广告过滤和DNS服务功能，所以该功能必须启用) -> SmartDNS（提供DNS防劫持和域名加速访问功能，如果你不了解该插件请只设置下面提到的【CN-ISP】，不要改动其它设置).

所以你的设置步骤应该是：【网络】【接口】->【SmartDNS】【CN-ISP】->【AdGuradHome】【更新核心】【使用53端口替换dnsmasq】【选择过滤规则】->可选使用【PassWall】插件。

- 你需要知道的信息

1. 默认IP:192.168.100.200
2. 路由账号:root
3. 路由密码:password
4. adg账号:admin
5. adg密码:password
6. passwall默认已添加免费订阅地址（订阅页 - 更新订阅信息即可获取地址)，然后进入passwall插件 【基本设置】 - 【主要】 将其中的【默认】选项中的【直连】改为获取到的机场，最后启用【主开关】，点击【保存】即可使用。
7. AdGuradHome插件需要先点击【更新核心版本】升级到最新核心，将【重定向】选项改为【使用53端口替换dnsmasq】，然后【保存】即可正常开始使用了。（如果需要广告过滤请点击【AdGuradHome Web:3000】按钮后，选择【过滤器】 - 【DNS封锁清单】，将需要的过滤规则启用即可。
8. SmartDNS我已经配置好了，你只需要将【上游服务器】中的【CN-ISP】中的IP改为你所在地运营商的DNS IP即可。（SmartDNS的作用主要是防污染和解析加速）

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

- 2021/06/21

  （请下6月21日凌晨3点之后的版本）
  1. 添加JD签到插件，方便获取cookies
  2. adg添加两项广告过滤规则（视频过滤，手机广告过滤)
  3. 更换一套新主题（目前主题挑选中，欢迎推荐，要求就是清爽，不要花里胡哨的）

- 2021/06/20

 1. 添加PassWall的默认配置。
 2. PassWall增加免费订阅。

- 2021/06/19

 1. 继续修复ADG核心更新失败的问题。

- 2021/06/18

1. 尝试集成adg，smartdns配置信息，争取做到开箱即用。

- 2021/06/12

 1. 第一补全说明,懒得写啦,功能就那几个而已.
 2. 下次一定


## 已知问题

- AdGuardHome 无法更新核心,重复提示:A task is already running.【最新版本已经解决更新问题，该方法可作为参考使用】

  解决方法:

1. 确认路由器是否联网成功.
  通过 网络 -> 网络诊断 -> NSLOOKUP 按钮是否能够获取到openwrt.org的解析地址判断.

2. 多次点击更新按钮依然出现 A task is already running. 是因为部分机型在代码中 check_if_already_running 检测机制被卡住造成.

  ```shell
  只需通过TTYD终端插件通过以下方式即可:
  1. 命令 cd /usr/share/AdGuardHome
  2. 命令 vi update_core.sh
  3. 按键盘i键进入编译模式
  4. 将以下代码注意掉(注释方法为行首添加#)
  注释掉内容页最上方的check_if_already_running函数

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


  注释掉内容页最下方Main函数中的check_if_already_running即可

  main(){  
        #check_if_already_running                                       
        check_latest_version
        $1
  }
  ```

## 问题反馈

1. 提交 lssues
2. 通过QQ群联系我.

## 鸣谢

感谢以下开源作者的开源项目以及详尽的文档,排名不分先后.

[P3TERX](https://github.com/P3TERX)

[coolsnowwolf](https://github.com/coolsnowwolf)

[kenzok8](https://github.com/kenzok8)

[Nick Peng](https://github.com/pymumu)

[tty228](https://github.com/tty228)

[Harry Gabriel](https://github.com/ozon)
