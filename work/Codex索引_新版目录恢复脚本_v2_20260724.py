import sqlite3
import sys
import time
from pathlib import Path


def backup_database(source_path: Path, backup_path: Path) -> None:
    backup_path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(source_path) as source:
        with sqlite3.connect(backup_path) as destination:
            source.backup(destination)


def load_active_threads(database_path: Path) -> list[tuple]:
    with sqlite3.connect(database_path) as connection:
        return connection.execute(
            """
            SELECT id,
                   COALESCE(NULLIF(title, ''), NULLIF(name, ''), '未命名任务'),
                   CAST(created_at AS REAL),
                   CAST(updated_at AS REAL),
                   cwd,
                   COALESCE(NULLIF(source, ''), 'vscode'),
                   COALESCE(NULLIF(model_provider, ''), 'custom'),
                   git_branch,
                   thread_source
            FROM threads
            WHERE archived = 0
            ORDER BY updated_at, id
            """
        ).fetchall()


def restore_catalog(legacy_path: Path, catalog_path: Path) -> tuple[int, int]:
    threads = load_active_threads(legacy_path)
    now_ms = int(time.time() * 1000)
    with sqlite3.connect(catalog_path) as connection:
        base_sequence = connection.execute(
            "SELECT COALESCE(MAX(observation_sequence), 0) FROM local_thread_catalog"
        ).fetchone()[0]
        before = connection.total_changes
        for offset, thread in enumerate(threads, start=1):
            (
                thread_id,
                title,
                created_at,
                updated_at,
                cwd,
                source_kind,
                model_provider,
                git_branch,
                thread_source,
            ) = thread
            connection.execute(
                """
                INSERT INTO local_thread_catalog (
                    host_id, thread_id, display_title, source_created_at,
                    source_updated_at, cwd, source_kind, source_detail,
                    model_provider, git_branch, observation_sequence,
                    missing_candidate, thread_source
                ) VALUES (
                    'local', ?, ?, ?, ?, ?, ?, NULL, ?, ?, ?, 0, ?
                )
                ON CONFLICT(host_id, thread_id) DO UPDATE SET
                    display_title = excluded.display_title,
                    source_created_at = excluded.source_created_at,
                    source_updated_at = excluded.source_updated_at,
                    cwd = excluded.cwd,
                    source_kind = excluded.source_kind,
                    model_provider = excluded.model_provider,
                    git_branch = excluded.git_branch,
                    observation_sequence = excluded.observation_sequence,
                    missing_candidate = 0,
                    thread_source = excluded.thread_source
                """,
                (
                    thread_id,
                    title,
                    created_at,
                    updated_at,
                    cwd,
                    source_kind,
                    model_provider,
                    git_branch,
                    base_sequence + offset,
                    thread_source,
                ),
            )

        max_updated_at = max((thread[3] for thread in threads), default=None)
        final_sequence = base_sequence + len(threads)
        connection.execute(
            """
            INSERT INTO local_thread_catalog_sync_state (
                host_id, watermark_updated_at, initial_build_complete,
                observation_sequence, last_full_reconciled_at
            ) VALUES ('local', ?, 1, ?, ?)
            ON CONFLICT(host_id) DO UPDATE SET
                watermark_updated_at = excluded.watermark_updated_at,
                initial_build_complete = 1,
                observation_sequence = excluded.observation_sequence,
                last_full_reconciled_at = excluded.last_full_reconciled_at
            """,
            (max_updated_at, final_sequence, now_ms),
        )
        connection.execute(
            "UPDATE local_thread_catalog_metadata SET catalog_revision = catalog_revision + 1 WHERE id = 1"
        )
        changed = connection.total_changes - before
        connection.commit()
    return len(threads), changed


def main() -> None:
    legacy_path = Path(sys.argv[1])
    catalog_path = Path(sys.argv[2])
    backup_path = Path(sys.argv[3])
    backup_database(catalog_path, backup_path)
    active_threads, changed = restore_catalog(legacy_path, catalog_path)
    print(
        f"active_threads={active_threads} changed={changed} "
        f"backup={backup_path}"
    )


if __name__ == "__main__":
    main()
