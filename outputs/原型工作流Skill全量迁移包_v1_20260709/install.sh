#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS_DIR="$SCRIPT_DIR/skills"
TARGET_SKILLS_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
BACKUP_DIR="$HOME/.codex/skills_backup_$(date +%Y%m%d_%H%M%S)"

SKILLS=(
  "requirement-analysis"
  "axure-prototype-design"
  "requirements-to-axure-html-prototype"
)

if [ ! -d "$SOURCE_SKILLS_DIR" ]; then
  echo "未找到 skills 目录：$SOURCE_SKILLS_DIR"
  exit 1
fi

mkdir -p "$TARGET_SKILLS_DIR"

backup_created=false
for skill in "${SKILLS[@]}"; do
  if [ ! -d "$SOURCE_SKILLS_DIR/$skill" ]; then
    echo "迁移包缺少 skill：$skill"
    exit 1
  fi

  if [ -d "$TARGET_SKILLS_DIR/$skill" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$TARGET_SKILLS_DIR/$skill" "$BACKUP_DIR/$skill"
    backup_created=true
  fi
done

for skill in "${SKILLS[@]}"; do
  cp -R "$SOURCE_SKILLS_DIR/$skill" "$TARGET_SKILLS_DIR/$skill"
done

echo "安装完成，目标目录：$TARGET_SKILLS_DIR"
echo "已安装："
for skill in "${SKILLS[@]}"; do
  echo "  - $skill"
done

if [ "$backup_created" = true ]; then
  echo "已有同名 skill 已备份到：$BACKUP_DIR"
else
  echo "未发现同名 skill，无需备份。"
fi

echo "项目 SOP 不会自动写入项目，请按需复制 project-rules/ 下的文件。"
