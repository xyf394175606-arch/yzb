#!/bin/zsh
set -eu

exec >> /Users/xuyunfeng/.codex/backup-20260724-1405-project-thread-index-repair/watcher.log 2>&1
set -x

python_bin="/Users/xuyunfeng/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3"
work_dir="/Users/xuyunfeng/Documents/k12/work"
state_file="/Users/xuyunfeng/.codex/.codex-global-state.json"
database_file="/Users/xuyunfeng/.codex/state_5.sqlite"
log_file="/Users/xuyunfeng/.codex/backup-20260724-1405-project-thread-index-repair/restore.log"

attempt=0
while /bin/ps -ax -o command= | /usr/bin/grep -q '^/Applications/[C]hatGPT.app/Contents/MacOS/ChatGPT$'; do
  attempt=$((attempt + 1))
  if (( attempt > 1200 )); then
    print "timeout: ChatGPT did not exit" >> "$log_file"
    exit 1
  fi
  /bin/sleep 0.5
done

cd "$work_dir"
"$python_bin" Codex索引_恢复脚本_v1_20260724.py "$state_file" "$database_file" >> "$log_file" 2>&1
"$python_bin" Codex索引_恢复脚本测试_v1_20260724.py "$state_file" "$database_file" >> "$log_file" 2>&1
print "restore_complete=$(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
/usr/bin/open -a ChatGPT
