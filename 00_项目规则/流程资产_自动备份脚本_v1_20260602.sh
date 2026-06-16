#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="/Users/xuyunfeng/Documents/k12"
BACKUP_ROOT="$PROJECT_ROOT/outputs/流程资产_模板仓库_v1_20260602"
DATE_STAMP="$(date '+%Y%m%d')"
TIME_STAMP="$(date '+%H:%M')"

mkdir -p "$BACKUP_ROOT"

if [ ! -d "$BACKUP_ROOT/.git" ]; then
  git -C "$BACKUP_ROOT" init
  git -C "$BACKUP_ROOT" config user.name "k12 项目主控助手"
  git -C "$BACKUP_ROOT" config user.email "k12-project-control@example.local"
fi

rsync -a --delete "$PROJECT_ROOT/AGENTS.md" "$BACKUP_ROOT/AGENTS.md"
rsync -a --delete "$PROJECT_ROOT/00_项目规则/" "$BACKUP_ROOT/00_项目规则/"
rsync -a --delete "$PROJECT_ROOT/13_任务卡片/" "$BACKUP_ROOT/13_任务卡片/"

cat > "$BACKUP_ROOT/流程资产_备份说明_v1_20260602.md" <<'EOF'
# 流程资产备份说明

## 背景

本仓库用于保存 k12 项目的多助手协作流程资产，便于后续还原、复用和部署到新项目。

## 备份范围

- AGENTS.md
- 00_项目规则/
- 13_任务卡片/

## 不包含内容

- 真实会议记录
- 用户业务材料
- work/ 临时材料
- 阶段业务产物
- 高保真 HTML 原型
- PRD
- 评审记录

## 使用方式

将本仓库复制或 clone 到新项目后，按还原部署说明复制规则文件，并运行初始化目录脚本创建标准项目目录。
EOF

cat > "$BACKUP_ROOT/流程资产_还原部署说明_v1_20260602.md" <<'EOF'
# 流程资产还原部署说明

## 还原步骤

1. 创建新的项目目录。
2. 将本仓库中的 `AGENTS.md`、`00_项目规则/`、`13_任务卡片/` 复制到新项目目录。
3. 在新项目目录中运行 `流程资产_初始化目录脚本_v1_20260602.sh`。
4. 按 `00_项目规则/后台对话创建清单_v1_20260602.md` 创建或刷新 01-09 号助手线程。
5. 由项目主控助手接收材料、分拣材料并调度助手。

## 注意事项

- 不要把旧项目的业务材料直接混入新项目。
- 新项目开始前应先确认项目路径和线程标题。
- 如果助手线程提示仍引用旧目录，应要求助手重新读取最新 `13_任务卡片/`。
EOF

cat > "$BACKUP_ROOT/流程资产_初始化目录脚本_v1_20260602.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

mkdir -p \
  00_项目规则 \
  01_会议记录 \
  02_会议分析 \
  03_需求提取 \
  04_需求澄清 \
  05_需求分析 \
  06_业务流程 \
  07_信息架构 \
  08_交互设计 \
  09_数据交互 \
  10_高保真原型 \
  11_需求文档 \
  12_评审记录 \
  13_任务卡片 \
  outputs \
  work
EOF

chmod +x "$BACKUP_ROOT/流程资产_初始化目录脚本_v1_20260602.sh"

{
  echo "# 流程资产清单"
  echo
  echo "## 文件清单"
  echo
  find "$BACKUP_ROOT" \
    -path "$BACKUP_ROOT/.git" -prune -o \
    -type f -print \
    | sed "s#^$BACKUP_ROOT/##" \
    | sort \
    | sed 's/^/- /'
} > "$BACKUP_ROOT/流程资产_清单_v1_20260602.md"

git -C "$BACKUP_ROOT" add .

if git -C "$BACKUP_ROOT" diff --cached --quiet; then
  echo "流程资产无变化，不生成新提交。"
else
  git -C "$BACKUP_ROOT" commit -m "自动备份流程资产 $DATE_STAMP $TIME_STAMP"
  echo "流程资产已备份并提交。"
fi
