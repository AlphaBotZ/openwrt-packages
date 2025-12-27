#!/bin/bash
set -e  # 出错立即退出

# ========== 配置项（根据你的需求修改） ==========
# 自己的插件仓库（SSH 地址，避免 HTTPS 输密码）
OWN_REPO="git@github.com:AlphaBotZ/openwrt-packages.git"

# 要同步的目标仓库列表（格式：仓库地址 插件目录 目标目录）
SYNC_LIST=(
    # 格式：源仓库地址 源插件目录 目标目录
    "https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest.git applications/luci-app-cloudflarespeedtest luci-app-cloudflarespeedtest"
    "https://github.com/immortalwrt-collections/openwrt-cdnspeedtest.git . cdnspeedtest"
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
)

# 临时工作目录
WORK_DIR="/tmp/openwrt_sync"
# ===============================================


# ========== 初始化工作目录 ==========
rm -rf "$WORK_DIR" && mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 克隆自己的仓库
git clone "$OWN_REPO" own_repo
cd own_repo


# ========== 遍历同步列表，复制插件 ==========
for ITEM in "${SYNC_LIST[@]}"; do
    # 拆分参数：源仓库地址、源目录、目标目录
    read -r SRC_REPO SRC_DIR DEST_DIR <<< "$ITEM"
    echo "===== 开始同步：$SRC_REPO → $DEST_DIR ====="

    # 克隆源仓库（浅克隆，只拉最新代码，节省时间）
    git clone --depth 1 "$SRC_REPO" src_repo

    # 删除旧的插件目录
    rm -rf "$DEST_DIR"
    mkdir -p "$DEST_DIR"

    # 判断源目录是否为根目录
    if [ "$SRC_DIR" = "." ]; then
        # 根目录插件：复制整个仓库内容（排除 .git）
        rsync -a --exclude='.git' src_repo/ "$DEST_DIR"/
        echo "✅ 同步成功：根目录 → $DEST_DIR"
    elif [ -d "src_repo/$SRC_DIR" ]; then
        # 子目录插件：复制指定目录
        rsync -a "src_repo/$SRC_DIR/" "$DEST_DIR"/
        echo "✅ 同步成功：$SRC_DIR → $DEST_DIR"
    else
        echo "❌ 源目录不存在：src_repo/$SRC_DIR，跳过"
    fi

    # 删除临时源仓库
    rm -rf src_repo
done


# ========== 提交并推送 ==========
git add .

# 检查是否有变更
if git diff --cached --quiet; then
    echo "😶 无代码变更，无需提交"
else
    git commit -m "Auto sync packages: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main  # 若主分支是 master，改为 master
    echo "🚀 代码已推送至自己的仓库"
fi


# ========== 清理临时目录 ==========
rm -rf "$WORK_DIR"
echo "🎉 同步任务完成"
