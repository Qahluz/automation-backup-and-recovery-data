#!/usr/bin/env bash

PROJECT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
DEMO="$PROJECT/tests/demo"
EVIDENCE="$PROJECT/evidence/07-ubuntu-server-demo"

SOURCE="$DEMO/source"
DEST="$PROJECT/output/demo-backup"

RESTORE_VALID="$DEMO/restore-valid"
RESTORE_BAD="$DEMO/restore-bad"

READONLY_DEST="$PROJECT/output/demo-readonly"

LOCK_SOURCE="$DEMO/lock/source"
LOCK_DEST="$PROJECT/output/demo-lock"

MONITOR_SOURCE="$DEMO/monitoring/source"
MONITOR_DEST="$PROJECT/output/demo-monitoring"

ACCESS_DIR="$DEMO/access-control"

MISSING_SOURCE="$DEMO/source-tidak-ada"
FILE_NOT_DIR="$PROJECT/README.md"

mkdir -p "$RESTORE_VALID" "$RESTORE_BAD"

# Menjalankan command sekaligus menyimpan output dan exit status.
run_evidence() {
    local name="$1"
    shift

    local logfile="$EVIDENCE/$name"
    mkdir -p "$(dirname "$logfile")"

    printf '$ ' > "$logfile"
    printf '%q ' "$@" >> "$logfile"
    printf '\n' >> "$logfile"

    "$@" 2>&1 | tee -a "$logfile"
    DEMO_LAST_STATUS=${PIPESTATUS[0]}

    printf 'Exit status: %s\n' "$DEMO_LAST_STATUS" | tee -a "$logfile"
    return 0
}

export PROJECT DEMO EVIDENCE SOURCE DEST
export RESTORE_VALID RESTORE_BAD READONLY_DEST
export LOCK_SOURCE LOCK_DEST MONITOR_SOURCE MONITOR_DEST
export ACCESS_DIR MISSING_SOURCE FILE_NOT_DIR
