#!/bin/bash
set -e  # 出错立即退出

# ========== 配置项 ==========
OWN_REPO="git@github.com:AlphaBotZ/openwrt-packages.git"
SYNC_LIST=(
    "https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest.git applications/luci-app-cloudflarespeedtest luci-app-cloudflarespeedtest"
    "https://github.com/immortalwrt-collections/openwrt-cdnspeedtest.git . cdnspeedtest"
    "https://github.com/destan19/OpenAppFilter.git . OpenAppFilter"
    "https://github.com/jerrykuku/luci-theme-argon.git . luci-theme-argon"
    "https://github.com/jerrykuku/luci-app-argon-config.git . luci-app-argon-config"
    "https://github.com/rufengsuixing/luci-app-zerotier.git . luci-app-zerotier"
    "https://github.com/xiaorouji/openwrt-passwall2.git luci-app-passwall2 luci-app-passwall2"
    "https://github.com/vernesong/OpenClash.git luci-app-openclash luci-app-openclash"
    "https://github.com/sbwml/luci-app-openlist2.git . luci-app-openlist2"
    "https://github.com/sbwml/luci-app-mosdns.git . luci-app-mosdns"
    "https://github.com/rufengsuixing/luci-app-adguardhome.git . luci-app-adguardhome"
)
WORK_DIR="/tmp/openwrt_sync"
# ===============================================

# 初始化工作目录
rm -rf "$WORK_DIR" && mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 克隆自己的仓库
git clone "$OWN_REPO" own_repo
cd own_repo

# ========== 定义函数 ==========
sync_plugin() {
    local SRC_REPO="$1"
    local SRC_DIR="$2"
    local DEST_DIR="$3"

    echo "===== 开始同步：$SRC_REPO → $DEST_DIR ====="
    git clone --depth 1 "$SRC_REPO" src_repo

    rm -rf "$DEST_DIR"
    mkdir -p "$DEST_DIR"

    if [ "$SRC_DIR" = "." ]; then
        # 根目录插件：复制所有文件（包括隐藏文件）
        cp -r src_repo/* "$DEST_DIR"/
        cp -r src_repo/.[!.]* "$DEST_DIR"/ 2>/dev/null || true
        echo "✅ 同步成功：根目录 → $DEST_DIR"
    elif [ -d "src_repo/$SRC_DIR" ]; then
        cp -r "src_repo/$SRC_DIR" "$DEST_DIR"
        echo "✅ 同步成功：$SRC_DIR → $DEST_DIR"
    else
        echo "❌ 源目录不存在：src_repo/$SRC_DIR，跳过"
    fi

    rm -rf src_repo
}

# 遍历列表并调用函数
for ITEM in "${SYNC_LIST[@]}"; do
    read -r SRC_REPO SRC_DIR DEST_DIR <<< "$ITEM"
    sync_plugin "$SRC_REPO" "$SRC_DIR" "$DEST_DIR"
done

# 提交并推送
git add .
if git diff --cached --quiet; then
    echo "😶 无代码变更，无需提交"
else
    git commit -m "Auto sync packages: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "🚀 代码已推送至自己的仓库"
fi

# 清理
rm -rf "$WORK_DIR"
echo "🎉 同步任务完成"
