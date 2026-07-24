import sqlite3
import sys
from pathlib import Path


def read_thread_ids(database_path: Path, query: str) -> set[str]:
    with sqlite3.connect(database_path) as connection:
        return {row[0] for row in connection.execute(query)}


def main() -> None:
    legacy_path = Path(sys.argv[1])
    catalog_path = Path(sys.argv[2])
    legacy_ids = read_thread_ids(
        legacy_path,
        "SELECT id FROM threads WHERE archived = 0",
    )
    catalog_ids = read_thread_ids(
        catalog_path,
        "SELECT thread_id FROM local_thread_catalog WHERE host_id = 'local' ",
    )
    missing = legacy_ids - catalog_ids
    print(
        f"legacy_active={len(legacy_ids)} catalog={len(catalog_ids)} "
        f"missing={len(missing)}"
    )
    if missing:
        sample = ", ".join(sorted(missing)[:5])
        raise AssertionError(f"new catalog is incomplete: {sample}")


if __name__ == "__main__":
    main()
