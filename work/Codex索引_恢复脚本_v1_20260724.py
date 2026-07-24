import json
import os
import sqlite3
import sys
from pathlib import Path

from Codex索引_恢复脚本测试_v1_20260724 import infer_project


def main():
    state_path = Path(sys.argv[1])
    database_path = Path(sys.argv[2])
    state = json.loads(state_path.read_text(encoding="utf-8"))
    projects = state.get("local-projects", {})
    assignments = state.setdefault("thread-project-assignments", {})

    with sqlite3.connect(database_path) as connection:
        threads = connection.execute("SELECT id, cwd FROM threads").fetchall()

    repaired = 0
    for thread_id, cwd in threads:
        project_id = infer_project(cwd, projects)
        if not project_id:
            continue
        expected = {
            "projectKind": "local",
            "projectId": project_id,
            "cwd": cwd,
            "pendingCoreUpdate": False,
        }
        if assignments.get(thread_id) != expected:
            assignments[thread_id] = expected
            repaired += 1

    temporary_path = state_path.with_name(state_path.name + ".repair-tmp")
    temporary_path.write_text(
        json.dumps(state, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )
    os.replace(temporary_path, state_path)
    print(f"repaired={repaired} assignments={len(assignments)}")


if __name__ == "__main__":
    main()
