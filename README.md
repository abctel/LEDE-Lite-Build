# 重要更新，已实现全配置默认写入，启动后修改网关即可使用。（启动后默认翻墙，如不需要翻墙请关闭passwall功能即可）

# 固件介绍

本固件订制原则是功能最小化，稳定运行为主，尤其适合作为单网口旁路有，虚拟机旁路有运行使用，同时也可作为对7x24稳定运行的朋友使用。

- 固件仅在原版lede基础上精简、添加日常常用到插件：

1. passwall              （翻墙）
2. AdGuardHome           (广告过滤)
3. SmartDNS              （DNS加速）
4. dnscrypt-proxy2       (DNS加密解析）
5. ChinaDNS-NG           （DNS防污染）
6. 动态DNS               （IP绑定）
7. KMS服务器             （内网windows家族软件激活）
8. TTYD终端              （超级方便的web ssh)
9. dnsmasq-china-list   （dnsmasq 加速识别）
10. open-vm-tool         (提升虚拟路由性能、支持虚拟机操作等）

- 重要提醒

 1. 该固件主要目的是满足翻墙->域名加速、防劫持->广告过滤，所以插件的设置存在设置逻辑，错误的修改和关闭、启用关联的插件会造成无法访问网络的问题。所以小白请勿任意改动【passwall】、【AdGuardHome】、【SmartDNS】、【dnscrypt-proxy2】、【ChinaDNS-NG】这几个插件的功能配置，直接启动后按照默认配置使用即可。
 
 2. 开机后需要进行的操作【网络】->【接口】->LAN的【修改】->【IPv4地址】改为主路由可分配IP段内任意地址->【IPv4网关】改为主路由分配的网关地址->【保存】
 
 3. 开机后需要进行的操作【服务】->【ChinaDNS-NG】->【规则更新】->【更新】
 
 4. 如需过滤广告则操作【服务】->【AdGuard Home】->【AdGuardHome Web:3000】->【过滤器】->【DNS封锁清单】->将需要的广告过滤规则启用即可。
 
- 你需要知道的信息

1. 默认IP:192.168.100.200
2. 所有需登录账号:root
3. 所有需登录密码:password
4. passwall默认打开翻墙功能，已配置好规则，如无需翻墙则进入passwall插件 【基本设置】 - 【主要】 将其中的【主开关】取消勾选，点击【保存】即可。
5. AdGuradHome如果需要广告过滤请点击【AdGuradHome Web:3000】按钮后，选择【过滤器】 - 【DNS封锁清单】，将需要的过滤规则启用即可。
6. SmartDNS我已经配置好了，你只需要将【上游服务器】中的【CN-ISP】中的IP改为你所在地运营商的DNS IP即可。（SmartDNS的作用主要是防污染和解析加速）

- 使用的主题：

1. edge

## 插件源

为保证固件的绝对安全，本固件只使用lean's作者、社区高度认可插件包、源头作者开源的插件.

## 更新说明

- 2021/8/15
  1. 重大更新，理清功能访问、搭配逻辑，实现国内、外DNS防污染、广告过滤。
  2. 固件已默认配置好所有需要的功能，实现开机即用。
  3. 取消jd签到插件（该插件的签到作者好像已放弃更新了）
  4. 取消网络唤醒插件（该固件正式确定为旁路由专用插件，大部分主软路由固件已有网络唤醒功能）
  5. 新增dnscrypt-proxy2插件
  6. 新增ChinaDNS-NG插件
  7. 新增dnsmasq-china-list插件
  8. 大量固件配置、性能优化等配置（太多了，就不一一表述）

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

- Q:AdGuardHome 无法更新核心,重复提示:A task is already running.【最新版本已经解决更新问题，该方法可作为参考使用】

  A:解决方法:

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
 
 - Q:passwall使用分流功能后，无法翻墙
   
   A:可能是上游最近的更新出现问题，还需要时间调试解决，目前通过节点方式使用已无问题，暂时将该问题搁置，计划在后期版本中解决。

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
