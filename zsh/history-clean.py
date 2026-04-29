#!/usr/bin/env python3
"""Interactively remove long commands from ~/.zsh_history using fzf.

Usage: history-clean.py [min_length]
  min_length: minimum command length to include (default: 100)
"""

import os
import sys
import subprocess
import time
from pathlib import Path

HISTORY_FILE = Path(os.environ.get('HISTFILE', os.path.expanduser('~/.zsh_history')))

args = [a for a in sys.argv[1:] if a != '-r']
RECENT_FIRST = '-r' in sys.argv[1:]
MIN_LENGTH = int(args[0]) if args else 100


def parse_entries(path: Path) -> list[str]:
    """Parse zsh history, grouping multi-line entries (lines ending with \\)."""
    text = path.read_bytes().decode('utf-8', errors='replace')
    entries, current = [], []
    for line in text.split('\n'):
        current.append(line)
        if not line.endswith('\\'):
            entry = '\n'.join(current)
            if entry.strip():
                entries.append(entry)
            current = []
    if current and ''.join(current).strip():
        entries.append('\n'.join(current))
    return entries


def entry_timestamp(entry: str) -> int | None:
    """Extract Unix timestamp from extended history entry (: ts:elapsed;cmd)."""
    if entry.startswith(': ') and ';' in entry:
        try:
            return int(entry[2:].split(':', 1)[0].strip())
        except ValueError:
            pass
    return None


def format_age(ts: int | None) -> str:
    if ts is None:
        return '?'
    secs = int(time.time()) - ts
    if secs < 3600:
        return f"{secs // 60}m"
    if secs < 86400:
        return f"{secs // 3600}h"
    if secs < 86400 * 30:
        return f"{secs // 86400}d"
    if secs < 86400 * 365:
        return f"{secs // (86400 * 30)}mo"
    return f"{secs // (86400 * 365)}y"


def command_text(entry: str) -> str:
    """Extract command from entry, collapsing continuation lines."""
    cmd = entry.split(';', 1)[1] if (entry.startswith(': ') and ';' in entry) else entry
    return cmd.replace('\\\n', ' ').strip()


def main():
    if not HISTORY_FILE.exists():
        print(f"History file not found: {HISTORY_FILE}", file=sys.stderr)
        sys.exit(1)

    entries = parse_entries(HISTORY_FILE)
    long_entries = [(i, e) for i, e in enumerate(entries) if len(command_text(e)) >= MIN_LENGTH]

    if not long_entries:
        print(f"No commands longer than {MIN_LENGTH} chars found.")
        return

    if RECENT_FIRST:
        long_entries = list(reversed(long_entries))

    fzf_input = '\n'.join(
        f"{i}\t{format_age(entry_timestamp(e)):>4}\t{command_text(e)}"
        for i, e in long_entries
    )

    result = subprocess.run(
        [
            'fzf', '--multi', '--reverse',
            '--with-nth=2..', '--delimiter=\t',
            '--bind=alt-a:select-all',
            '--header=TAB: select  ALT-A: select all  ENTER: remove selected  ESC: cancel',
            '--preview=echo {3..}',
            '--preview-window=up:4:wrap',
        ],
        input=fzf_input, capture_output=True, text=True,
    )

    if result.returncode != 0 or not result.stdout.strip():
        print("Nothing removed.")
        return

    to_remove = {int(line.split('\t')[0]) for line in result.stdout.strip().split('\n') if line}

    backup = HISTORY_FILE.parent / (HISTORY_FILE.name + '.bak')
    backup.write_bytes(HISTORY_FILE.read_bytes())
    print(f"Backup saved to {backup}")

    kept = [e for i, e in enumerate(entries) if i not in to_remove]
    HISTORY_FILE.write_text('\n'.join(kept) + '\n', encoding='utf-8')
    print(f"Removed {len(to_remove)} command(s).")


if __name__ == '__main__':
    main()
