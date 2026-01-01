#!/bin/bash
set -e  # 出错立即退出

# ========== 配置项 ==========
OWN_REPO="git@github.com:AlphaBotZ/openwrt-packages.git"

SYNC_LIST=(
    "https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest.git applications/luci-app-cloudflarespeedtest luci-app-cloudflarespeedtest"
    "https://github.com/immortalwrt-collections/openwrt-cdnspeedtest.git cdnspeedtest cdnspeedtest"
    "https://github.com/destan19/OpenAppFilter.git . OpenAppFilter"
    "https://github.com/nikkinikki-org/OpenWrt-nikki.git . OpenWrt-nikki"
    "https://github.com/jerrykuku/luci-theme-argon.git . luci-theme-argon"
    "https://github.com/jerrykuku/luci-app-argon-config.git . luci-app-argon-config"
    "https://github.com/rufengsuixing/luci-app-zerotier.git . luci-app-zerotier"
    "https://github.com/xiaorouji/openwrt-passwall2.git luci-app-passwall2 luci-app-passwall2"
    "https://github.com/vernesong/OpenClash.git luci-app-openclash luci-app-openclash"
    "https://github.com/sbwml/luci-app-openlist2.git . luci-app-openlist2"
    "https://github.com/sbwml/luci-app-mosdns.git . luci-app-mosdns"
    "https://github.com/rufengsuixing/luci-app-adguardhome.git . luci-app-adguardhome"
    "https://github.com/linkease/istore.git . luci-app-store"
    "https://github.com/fw876/helloworld.git . helloworld"
    "https://github.com/BCYDTZ/luci-app-UUGameAcc.git . luci-app-UUGameAcc"
    "https://github.com/kenzok8/small-package.git luci-app-ssr-plus luci-app-ssr-plus"
    "https://github.com/douglarek/luci-app-homeproxy.git . luci-app-homeproxy"
    "https://github.com/kiddin9/luci-app-dnsfilter . luci-app-dnsfilter"
    "https://github.com/kiddin9/aria2 . aria2"
    "https://github.com/kiddin9/luci-app-baidupcs-web . luci-app-baidupcs-web"
    "https://github.com/kiddin9/autoshare . autoshare"
    "https://github.com/kiddin9/openwrt-openvpn . openwrt-openvpn"
    "https://github.com/kiddin9/luci-app-xlnetacc . luci-app-xlnetacc"
    "https://github.com/kiddin9/luci-app-wizard . luci-app-wizard"
    "https://github.com/kiddin9/luci-theme-edge . luci-theme-edge"
    "https://github.com/derisamedia/luci-theme-alpha . luci-theme-alpha"
    "https://github.com/animegasan/luci-app-alpha-config . luci-app-alpha-config"
    "https://github.com/yichya/luci-app-xray . luci-app-xray"
    "https://github.com/Lienol/openwrt-package . openwrt-package"
    "https://github.com/ysc3839/openwrt-minieap . openwrt-minieap"
    "https://github.com/ysc3839/luci-proto-minieap . luci-proto-minieap"
    "https://github.com/BoringCat/luci-app-mentohust . luci-app-mentohust"
    "https://github.com/BoringCat/luci-app-minieap . luci-app-minieap"
    "https://github.com/peter-tank/luci-app-dnscrypt-proxy2 . luci-app-dnscrypt-proxy2"
    "https://github.com/peter-tank/luci-app-autorepeater . luci-app-autorepeater"
    "https://github.com/rufengsuixing/luci-app-autoipsetadder . luci-app-autoipsetadder"
    "https://github.com/ElvenP/luci-app-onliner . luci-app-onliner"
    "https://github.com/rufengsuixing/luci-app-usb3disable . luci-app-usb3disable"
    "https://github.com/riverscn/openwrt-iptvhelper . openwrt-iptvhelper"
    "https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk . MentoHUST-OpenWrt-ipk"
    "https://github.com/NateLol/luci-app-beardropper . luci-app-beardropper"
    "https://github.com/yaof2/luci-app-ikoolproxy . luci-app-ikoolproxy"
    "https://github.com/project-lede/luci-app-godproxy . luci-app-godproxy"
    "https://github.com/tty228/luci-app-wechatpush . luci-app-wechatpush"
    "https://github.com/4IceG/luci-app-sms-tool . luci-app-sms-tool"
    "https://github.com/silime/luci-app-xunlei . luci-app-xunlei"
    "https://github.com/BCYDTZ/luci-app-UUGameAcc . luci-app-UUGameAcc"
    "https://github.com/ntlf9t/luci-app-easymesh . luci-app-easymesh"
    "https://github.com/zzsj0928/luci-app-pushbot . luci-app-pushbot"
    "https://github.com/shanglanxin/luci-app-homebridge . luci-app-homebridge"
    "https://github.com/esirplayground/luci-app-poweroff . luci-app-poweroff"
    "https://github.com/esirplayground/LingTiGameAcc . LingTiGameAcc"
    "https://github.com/esirplayground/luci-app-LingTiGameAcc . luci-app-LingTiGameAcc"
    "https://github.com/brvphoenix/luci-app-wrtbwmon . luci-app-wrtbwmon"
    "https://github.com/brvphoenix/wrtbwmon . wrtbwmon"
    "https://github.com/jerrykuku/luci-app-ttnode . luci-app-ttnode"
    "https://github.com/jerrykuku/luci-app-go-aliyundrive-webdav . luci-app-go-aliyundrive-webdav"
    "https://github.com/jerrykuku/lua-maxminddb . lua-maxminddb"
    "https://github.com/sirpdboy/luci-app-advanced . luci-app-advanced"
    "https://github.com/sirpdboy/luci-theme-opentopd . luci-theme-opentopd"
    "https://github.com/sirpdboy/luci-app-poweroffdevice . luci-app-poweroffdevice"
    "https://github.com/sirpdboy/luci-app-autotimeset . luci-app-autotimeset"
    "https://github.com/sirpdboy/luci-app-lucky . luci-app-lucky"
    "https://github.com/sirpdboy/luci-app-partexp . luci-app-partexp"
    "https://github.com/sirpdboy/luci-app-netdata . luci-app-netdata"
    "https://github.com/sirpdboy/luci-app-chatgpt-web . luci-app-chatgpt-web"
    "https://github.com/sirpdboy/luci-app-eqosplus . luci-app-eqosplus"
    "https://github.com/sirpdboy/luci-app-ddns-go . luci-app-ddns-go"
    "https://github.com/sirpdboy/netspeedtest . netspeedtest"
    "https://github.com/KFERMercer/luci-app-tcpdump . luci-app-tcpdump"
    "https://github.com/jefferymvp/luci-app-koolproxyR . luci-app-koolproxyR"
    "https://github.com/wolandmaster/luci-app-rtorrent . luci-app-rtorrent"
    "https://github.com/NateLol/luci-app-oled . luci-app-oled"
    "https://github.com/hubbylei/luci-app-clash . luci-app-clash"
    "https://github.com/destan19/OpenAppFilter . OpenAppFilter"
    "https://github.com/lvqier/luci-app-dnsmasq-ipset . luci-app-dnsmasq-ipset"
    "https://github.com/walkingsky/luci-wifidog . luci-wifidog"
    "https://github.com/CCnut/feed-netkeeper . feed-netkeeper"
    "https://github.com/sensec/luci-app-udp2raw . luci-app-udp2raw"
    "https://github.com/LGA1150/openwrt-sysuh3c . openwrt-sysuh3c"
    "https://github.com/Hyy2001X/AutoBuild-Packages . AutoBuild-Packages"
    "https://github.com/lisaac/luci-app-dockerman . luci-app-dockerman"
    "https://github.com/gdck/luci-app-cupsd . luci-app-cupsd"
    "https://github.com/kenzok8/wall . wall"
    "https://github.com/peter-tank/luci-app-fullconenat . luci-app-fullconenat"
    "https://github.com/sirpdboy/sirpdboy-package . sirpdboy-package"
    "https://github.com/sundaqiang/openwrt-packages . sundaqiang-packages"
    "https://github.com/zxlhhyccc/luci-app-v2raya . luci-app-v2raya"
    "https://github.com/kenzok8/luci-theme-ifit . luci-theme-ifit"
    "https://github.com/kenzok78/openwrt-minisign . openwrt-minisign"
    "https://github.com/kenzok78/luci-app-adguardhome . luci-app-adguardhome"
    "https://github.com/kenzok78/luci-theme-design . luci-theme-design"
    "https://github.com/kenzok78/luci-app-design-config . luci-app-design-config"
    "https://github.com/pymumu/luci-app-smartdns . luci-app-smartdns"
    "https://github.com/ophub/luci-app-amlogic . luci-app-amlogic"
    "https://github.com/linkease/nas-packages . nas-packages"
    "https://github.com/linkease/nas-packages-luci . nas-packages-luci"
    "https://github.com/AlexZhuo/luci-app-bandwidthd . luci-app-bandwidthd"
    "https://github.com/linkease/openwrt-app-actions . openwrt-app-actions"
    "https://github.com/ZeaKyX/luci-app-speedtest-web . luci-app-speedtest-web"
    "https://github.com/ZeaKyX/speedtest-web . speedtest-web"
    "https://github.com/Zxilly/UA2F . UA2F"
    "https://github.com/Huangjoe123/luci-app-eqos . luci-app-eqos"
    "https://github.com/honwen/luci-app-aliddns . luci-app-aliddns"
    "https://github.com/muink/luci-app-dnsproxy . luci-app-dnsproxy"
    "https://github.com/ximiTech/luci-app-msd_lite . luci-app-msd_lite"
    "https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic . luci-app-unblockneteasemusic"
    "https://github.com/sbwml/luci-app-alist . luci-app-alist"
    "https://github.com/sbwml/luci-app-qbittorrent . luci-app-qbittorrent"
    "https://github.com/messense/aliyundrive-webdav . aliyundrive-webdav"
    "https://github.com/messense/aliyundrive-fuse . aliyundrive-fuse"
    "https://github.com/sbwml/luci-app-mosdns . luci-app-mosdns"
    "https://github.com/xiaorouji/openwrt-passwall . openwrt-passwall"
    "https://github.com/SSSSSimon/tencentcloud-openwrt-plugin-ddns . tencentcloud-openwrt-plugin-ddns"
    "https://github.com/Tencent-Cloud-Plugins/tencentcloud-openwrt-plugin-cos . tencentcloud-openwrt-plugin-cos"
    "https://github.com/kiddin9/kwrt-packages . kwrt-packages"
    "https://github.com/doushang/luci-app-shortcutmenu . luci-app-shortcutmenu"
    "https://github.com/sbilly/netmaker-openwrt . netmaker-openwrt"
    "https://github.com/gSpotx2f/luci-app-internet-detector . luci-app-internet-detector"
    "https://github.com/vinewx/NanoHatOLED . NanoHatOLED"
    "https://github.com/zerolabnet/luci-app-torbp . luci-app-torbp"
    "https://github.com/muink/luci-app-tinyfilemanager . luci-app-tinyfilemanager"
    "https://github.com/sbwml/luci-app-airconnect . luci-app-airconnect"
    "https://github.com/blueberry-pie-11/luci-app-natmap . luci-app-natmap"
    "https://github.com/QiuSimons/luci-app-daed-next . luci-app-daed-next"
    "https://github.com/nikkinikki-org/OpenWrt-momo . OpenWrt-momo"
    "https://github.com/muink/openwrt-fchomo . openwrt-fchomo"
    "https://github.com/lucikap/luci-app-brukamen . luci-app-brukamen"
    "https://github.com/Thaolga/openwrt-nekobox . openwrt-nekobox"
    "https://github.com/Carseason/openwrt-packages . openwrt-packages"
    "https://github.com/Carseason/openwrt-themedog . openwrt-themedog"
    "https://github.com/Carseason/openwrt-app-actions . openwrt-app-actions"
    "https://github.com/Akimio521/luci-app-gecoosac . luci-app-gecoosac"
    "https://github.com/EasyTier/luci-app-easytier . luci-app-easytier"
    "https://github.com/asvow/luci-app-tailscale . luci-app-tailscale"
    "https://github.com/kiddin9/openwrt-netdata . openwrt-netdata"
    "https://github.com/kiddin9/openwrt-my-dnshelper . openwrt-my-dnshelper"
    "https://github.com/kiddin9/openwrt-lingtigameacc . openwrt-lingtigameacc"
    "https://github.com/kiddin9/luci-app-timewol . luci-app-timewol"
    "https://github.com/kiddin9/luci-app-vsftpd . luci-app-vsftpd"
    "https://github.com/kiddin9/openwrt-subconverter . openwrt-subconverter"
    "https://github.com/kiddin9/luci-app-syncdial . luci-app-syncdial"
    "https://github.com/sbwml/luci-app-webdav . luci-app-webdav"
    "https://github.com/sirpdboy/luci-app-taskplan . luci-app-taskplan"
    "https://github.com/sirpdboy/luci-app-watchdog . luci-app-watchdog"
    "https://github.com/sirpdboy/luci-app-timecontrol . luci-app-timecontrol"
    "https://github.com/sirpdboy/luci-theme-kucat . luci-theme-kucat"
    "https://github.com/muink/openwrt-fastfetch . openwrt-fastfetch"
    "https://github.com/linkease/lcdsimple . lcdsimple"
    "https://github.com/Wulnut/luci-app-suselogin . luci-app-suselogin"
    "https://github.com/Ausaci/luci-app-nat6-helper . luci-app-nat6-helper"
    "https://github.com/animegasan/luci-app-droidmodem . luci-app-droidmodem"
    "https://github.com/kenzok78/luci-app-guest-wifi . luci-app-guest-wifi"
    "https://github.com/EkkoG/openwrt-natmap . openwrt-natmap"
    "https://github.com/EkkoG/luci-app-natmap . luci-app-natmap"
    "https://github.com/EasyTier/luci-app-easytier . luci-app-easytier"
    "https://github.com/sbwml/luci-app-openlist2 . luci-app-openlist2"
    "https://github.com/AngelaCooljx/luci-theme-material3 . luci-theme-material3"
    "https://github.com/vison-v/luci-app-nginx-proxy . luci-app-nginx-proxy"
    "https://github.com/EasyTier/luci-app-easytier . luci-app-easytier"
    "https://github.com/AngelaCooljx/luci-theme-material3 . luci-theme-material3"
    "https://github.com/vison-v/luci-app-nginx-proxy . luci-app-nginx-proxy"
)

WORK_DIR="/tmp/openwrt_sync"
# ===============================================


# 初始化工作目录
rm -rf "$WORK_DIR" && mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 克隆自己的仓库
git clone "$OWN_REPO" own_repo
cd own_repo


# 遍历同步列表，复制插件
for ITEM in "${SYNC_LIST[@]}"; do
    # 拆分参数（兼容空格分隔的三个参数）
    read -r SRC_REPO SRC_DIR DEST_DIR <<< "$ITEM"
    echo -e "\n===== 开始同步：$SRC_REPO → $DEST_DIR ====="
    
    # 克隆源仓库（浅克隆，只拉最新代码，节省时间）
    git clone --depth 1 "$SRC_REPO" src_repo
    
    # 处理源路径：SRC_DIR为.时表示源仓库根目录
    if [ "$SRC_DIR" = "." ]; then
        SRC_PATH="src_repo"  # 根目录
    else
        SRC_PATH="src_repo/$SRC_DIR"  # 子目录
    fi

    # 检查源路径是否存在
    if [ -d "$SRC_PATH" ]; then
        # 删除旧的目标目录（如果存在）
        rm -rf "$DEST_DIR"
        # 创建目标目录（确保父目录存在）
        mkdir -p "$DEST_DIR"
        # 复制源路径下所有内容（包括隐藏文件）到目标目录
        # 使用 /. 确保复制目录内的内容，而非目录本身
        cp -r "$SRC_PATH"/. "$DEST_DIR"/
        # 清理可能复制过来的git元数据（避免冲突）
        rm -rf "$DEST_DIR/.git" "$DEST_DIR/.gitignore" "$DEST_DIR/.github"
        echo "✅ 同步成功：$SRC_PATH → $DEST_DIR"
    else
        echo "❌ 源路径不存在：$SRC_PATH，跳过"
    fi
    
    # 删除临时源仓库
    rm -rf src_repo
done

# 提交并推送代码到自己的仓库
git add .
# 检查是否有变更
if git diff --cached --quiet; then
    echo -e "\n😶 无代码变更，无需提交"
else
    git commit -m "Auto sync packages: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main  # 若主分支是 master，改为 master
    echo -e "\n🚀 代码已推送至自己的仓库"
fi

# 清理临时目录
rm -rf "$WORK_DIR"
echo -e "\n🎉 同步任务完成"
