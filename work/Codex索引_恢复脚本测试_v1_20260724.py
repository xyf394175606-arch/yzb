import json
import sqlite3
import sys
from pathlib import Path


def load_inputs(state_path: Path, database_path: Path):
    state = json.loads(state_path.read_text(encoding="utf-8"))
    with sqlite3.connect(database_path) as connection:
        threads = connection.execute("SELECT id, cwd FROM threads").fetchall()
    return state, threads


def infer_project(cwd: str, projects: dict):
    roots = []
    basenames = {}
    for project_id, project in projects.items():
        for root in project.get("rootPaths", []):
            roots.append((len(root), root, project_id))
            basenames.setdefault(Path(root).name, []).append(project_id)

    for _, root, project_id in sorted(roots, reverse=True):
        if cwd == root or cwd.startswith(root + "/"):
            return project_id

    parts = Path(cwd).parts
    if len(parts) >= 2 and ".codex" in parts and "worktrees" in parts:
        candidates = basenames.get(Path(cwd).name, [])
        if len(candidates) == 1:
            return candidates[0]
    return None


def main():
    state_path = Path(sys.argv[1])
    database_path = Path(sys.argv[2])
    state, threads = load_inputs(state_path, database_path)
    projects = state.get("local-projects", {})
    assignments = state.get("thread-project-assignments", {})

    inferred = {
        thread_id: project_id
        for thread_id, cwd in threads
        if (project_id := infer_project(cwd, projects))
    }
    missing = {
        thread_id: project_id
        for thread_id, project_id in inferred.items()
        if assignments.get(thread_id, {}).get("projectId") != project_id
    }

    print(
        f"projects={len(projects)} threads={len(threads)} "
        f"inferred={len(inferred)} missing_or_wrong={len(missing)}"
    )
    if missing:
        sample = ", ".join(list(missing)[:5])
        raise AssertionError(f"project thread index is incomplete: {sample}")


if __name__ == "__main__":
    main()
