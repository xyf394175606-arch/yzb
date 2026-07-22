#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ARCHIVE_ROOT="/Users/xuyunfeng/Desktop/工作与生活 ob/工作生活/macmini/优坐标—课个人中心-入口权限配置"

DEFAULT_FILES=(
  "05_需求分析/需求分析_个人中心入口权限控制_v1_20260623.md"
  "10_高保真原型/高保真原型_个人中心入口配置_v1_20260623.html"
  "10_高保真原型/高保真原型_个人中心入口配置说明_v1_20260623.md"
)

if [ "$#" -gt 0 ]; then
  FILES=("$@")
else
  FILES=("${DEFAULT_FILES[@]}")
fi

mkdir -p "$ARCHIVE_ROOT/05_需求分析" "$ARCHIVE_ROOT/10_高保真原型" "$ARCHIVE_ROOT/附件"

for relative_path in "${FILES[@]}"; do
  case "$relative_path" in
    /*|*".."*)
      echo "不允许的项目相对路径：$relative_path" >&2
      exit 1
      ;;
  esac

  source_file="$PROJECT_ROOT/$relative_path"
  if [ ! -f "$source_file" ]; then
    echo "源文件不存在：$relative_path" >&2
    exit 1
  fi

  case "$relative_path" in
    附件/*)
      archive_file="$ARCHIVE_ROOT/$relative_path"
      ;;
    0[5-9]_*/?*|10_*/?*|11_*/?*|12_*/?*)
      archive_file="$ARCHIVE_ROOT/$relative_path"
      ;;
    *)
      echo "仅允许同步专题阶段产物或附件：$relative_path" >&2
      exit 1
      ;;
  esac

  mkdir -p "$(dirname "$archive_file")"
  cp -p "$source_file" "$archive_file"

  source_size="$(stat -f '%z' "$source_file")"
  archive_size="$(stat -f '%z' "$archive_file")"
  source_hash="$(shasum -a 256 "$source_file" | awk '{print $1}')"
  archive_hash="$(shasum -a 256 "$archive_file" | awk '{print $1}')"

  if [ "$source_size" != "$archive_size" ] || [ "$source_hash" != "$archive_hash" ]; then
    echo "同步校验失败：$relative_path" >&2
    exit 1
  fi

  echo "已同步并校验：$relative_path"
done
