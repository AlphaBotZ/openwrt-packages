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
