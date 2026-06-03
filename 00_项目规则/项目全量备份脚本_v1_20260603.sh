#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/Users/xuyunfeng/Documents/k12"
BACKUP_DIR="$ROOT_DIR/outputs/项目全量备份仓库_v1_20260603"
LOG_FILE="$ROOT_DIR/outputs/项目全量备份记录_v1_20260603.md"
NODE_NAME="${1:-节点备份}"

DATE_COMPACT="$(date '+%Y%m%d')"
TIME_COMPACT="$(date '+%H:%M')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
COMMIT_MESSAGE="节点备份 ${NODE_NAME} ${DATE_COMPACT} ${TIME_COMPACT}"

mkdir -p "$BACKUP_DIR"
mkdir -p "$ROOT_DIR/outputs"

if [ ! -d "$BACKUP_DIR/.git" ]; then
  git -C "$BACKUP_DIR" init >/dev/null
fi

sync_path() {
  local source_path="$1"
  local target_path="$2"
  if [ -e "$source_path" ]; then
    mkdir -p "$(dirname "$target_path")"
    if [ -d "$source_path" ]; then
      mkdir -p "$target_path"
      rsync -a --delete \
        --exclude '.git/' \
        --exclude '.DS_Store' \
        --exclude '项目全量备份仓库_v1_20260603/' \
        --exclude '流程资产_模板仓库_v1_20260602/.git/' \
        "$source_path/" "$target_path/"
    else
      cp "$source_path" "$target_path"
    fi
  fi
}

sync_path "$ROOT_DIR/AGENTS.md" "$BACKUP_DIR/AGENTS.md"

for dir in \
  "00_项目规则" \
  "01_会议记录" \
  "02_会议分析" \
  "03_需求提取" \
  "04_需求澄清" \
  "05_需求分析" \
  "06_业务流程" \
  "07_信息架构" \
  "08_交互设计" \
  "09_数据交互" \
  "10_高保真原型" \
  "11_需求文档" \
  "12_评审记录" \
  "13_任务卡片" \
  "work"; do
  sync_path "$ROOT_DIR/$dir" "$BACKUP_DIR/$dir"
done

mkdir -p "$BACKUP_DIR/outputs"
if [ -f "$ROOT_DIR/00_项目规则/项目全量备份规则_v1_20260603.md" ]; then
  sync_path "$ROOT_DIR/00_项目规则/项目全量备份规则_v1_20260603.md" "$BACKUP_DIR/00_项目规则/项目全量备份规则_v1_20260603.md"
fi

cat > "$BACKUP_DIR/项目全量备份_还原说明_v1_20260603.md" <<'EOF'
# 项目全量备份还原说明

## 用途

本仓库用于还原 k12 项目当前业务产物、流程规则、任务卡片、主控工作记录和阶段输出。

## 还原方式

1. 查看 Git 提交记录，选择目标节点。
2. 将本仓库中的项目文件复制回 `/Users/xuyunfeng/Documents/k12/`。
3. 还原后由项目主控检查目录、文件命名、阶段产物和台账一致性。

## 注意

- 本仓库不包含项目外部下载目录中的原始文件正文，除非文件已复制进 k12 项目目录。
- `流程资产_模板仓库` 用于流程复用；本仓库用于当前项目还原。
EOF

if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" <<'EOF'
# 项目全量备份记录

## 背景

本文件记录 10 号备份助手执行的全项目节点备份。

## 备份记录

| 时间 | 触发节点 | 提交信息 | 提交结果 | 提交哈希 | 异常情况 | 下一步动作 |
| --- | --- | --- | --- | --- | --- | --- |
EOF
fi

git -C "$BACKUP_DIR" add -A

if git -C "$BACKUP_DIR" diff --cached --quiet; then
  RESULT="无变化，未生成新提交"
  COMMIT_HASH="-"
else
  RESULT="已提交"
  COMMIT_HASH="提交后生成"
fi

printf '| %s | %s | %s | %s | %s | 无 | 成功则无需用户处理 |\n' \
  "$TIMESTAMP" "$NODE_NAME" "$COMMIT_MESSAGE" "$RESULT" "$COMMIT_HASH" >> "$LOG_FILE"

sync_path "$LOG_FILE" "$BACKUP_DIR/outputs/项目全量备份记录_v1_20260603.md"
git -C "$BACKUP_DIR" add -A

if git -C "$BACKUP_DIR" diff --cached --quiet; then
  RESULT="无变化，未生成新提交"
  COMMIT_HASH="-"
else
  git -C "$BACKUP_DIR" commit -m "$COMMIT_MESSAGE" >/dev/null
  COMMIT_HASH="$(git -C "$BACKUP_DIR" rev-parse --short HEAD)"
fi

echo "项目全量备份完成：$RESULT $COMMIT_HASH"
