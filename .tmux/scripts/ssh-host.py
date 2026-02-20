#!/usr/bin/env python3

import shlex
import subprocess
import sys
from typing import Optional


def _get_cmdline_for_pid(pid: str) -> str:
    out = subprocess.check_output(["ps", "-o", "command=", "-p", pid], text=True)
    return out.strip()


def _normalize_tty(tty: str) -> str:
    tty = tty.strip()
    if tty.startswith("/dev/"):
        return tty[len("/dev/") :]
    return tty


def _list_tty_processes(tty: str) -> list[tuple[int, str]]:
    tty = _normalize_tty(tty)
    out = subprocess.check_output(["ps", "-t", tty, "-o", "pid=", "-o", "command="], text=True)
    procs: list[tuple[int, str]] = []
    for line in out.splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split(maxsplit=1)
        if not parts:
            continue
        try:
            pid = int(parts[0])
        except ValueError:
            continue
        cmd = parts[1] if len(parts) > 1 else ""
        procs.append((pid, cmd.strip()))
    return procs


_OPTS_REQUIRING_ARG = {
    "-b",
    "-c",
    "-D",
    "-E",
    "-e",
    "-F",
    "-I",
    "-i",
    "-J",
    "-L",
    "-l",
    "-m",
    "-O",
    "-o",
    "-p",
    "-Q",
    "-R",
    "-S",
    "-W",
    "-w",
}


def _parse_destination(cmdline: str) -> Optional[str]:
    try:
        argv = shlex.split(cmdline)
    except ValueError:
        argv = cmdline.split()

    if not argv:
        return None

    # Find the ssh token (usually argv[0], but allow full path).
    ssh_i = None
    for i, tok in enumerate(argv):
        if tok == "ssh" or tok.endswith("/ssh"):
            ssh_i = i
            break
    if ssh_i is None:
        return None

    i = ssh_i + 1
    while i < len(argv):
        tok = argv[i]

        if tok == "--":
            i += 1
            return argv[i] if i < len(argv) else None

        if tok.startswith("-") and tok != "-":
            # Options with separate args.
            if tok in _OPTS_REQUIRING_ARG:
                i += 2
                continue

            # Inline forms like -p22, -Jjump, -oFoo=bar, etc.
            if tok[:2] in _OPTS_REQUIRING_ARG and tok != tok[:2]:
                i += 1
                continue

            # Unknown option; assume no arg.
            i += 1
            continue

        # First non-option token is the destination.
        return tok

    return None


def _is_ssh_cmd(cmdline: str) -> bool:
    if not cmdline:
        return False
    try:
        argv0 = shlex.split(cmdline, posix=True)[0]
    except Exception:
        argv0 = cmdline.split(maxsplit=1)[0]
    return argv0 == "ssh" or argv0.endswith("/ssh")


def _extract_host(destination: str) -> Optional[str]:
    dest = destination.strip()
    if not dest:
        return None

    # ssh://[user@]host[:port][/path]
    if dest.startswith("ssh://"):
        rest = dest[len("ssh://") :]
        rest = rest.split("/", 1)[0]
        rest = rest.split("@")[-1]
        host = rest.split(":", 1)[0]
    else:
        host = dest.split("@")[-1]

    if host.startswith("[") and host.endswith("]"):
        host = host[1:-1]

    return host or None


def main() -> int:
    if len(sys.argv) != 2:
        sys.stdout.write("?")
        return 0

    target = sys.argv[1]

    cmdline: Optional[str] = None
    try:
        if target.isdigit():
            cmdline = _get_cmdline_for_pid(target)
        else:
            procs = _list_tty_processes(target)
            ssh_procs = [(pid, cmd) for (pid, cmd) in procs if _is_ssh_cmd(cmd)]
            if ssh_procs:
                cmdline = max(ssh_procs, key=lambda t: t[0])[1]
    except Exception:
        sys.stdout.write("?")
        return 0

    if not cmdline:
        sys.stdout.write("?")
        return 0

    if not _is_ssh_cmd(cmdline):
        sys.stdout.write("?")
        return 0

    dest = _parse_destination(cmdline)
    host = _extract_host(dest) if dest else None

    sys.stdout.write(host or "?")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
