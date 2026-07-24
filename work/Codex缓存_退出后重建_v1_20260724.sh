#!/bin/zsh
set -eu

support_dir="/Users/xuyunfeng/Library/Application Support/Codex"
backup_dir="/Users/xuyunfeng/.codex/backup-20260724-renderer-cache-rebuild"
log_file="$backup_dir/rebuild.log"

/bin/mkdir -p "$backup_dir"
exec >> "$log_file" 2>&1
print "watcher_started=$(date '+%Y-%m-%d %H:%M:%S')"

attempt=0
while /bin/ps -ax -o command= | /usr/bin/grep -q '^/Applications/[C]hatGPT.app/Contents/MacOS/ChatGPT$'; do
  attempt=$((attempt + 1))
  if (( attempt > 1200 )); then
    print "timeout: ChatGPT did not exit"
    exit 1
  fi
  /bin/sleep 0.5
done

for cache_name in "Cache" "Code Cache" "GPUCache"; do
  source_path="$support_dir/$cache_name"
  destination_path="$backup_dir/$cache_name"
  if [[ -e "$source_path" && ! -e "$destination_path" ]]; then
    /bin/mv "$source_path" "$destination_path"
    print "moved=$source_path"
  fi
done

print "cache_rebuild_ready=$(date '+%Y-%m-%d %H:%M:%S')"
/usr/bin/open -a ChatGPT
