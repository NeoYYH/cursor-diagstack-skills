#!/usr/bin/env bash
# Install ass (ASS) skill to user skill dirs Cursor actually scans.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_NAME="ass"
SRC="${REPO_ROOT}/skills/${SKILL_NAME}"

if [[ ! -d "${SRC}" ]]; then
  echo "Skill source not found: ${SRC}" >&2
  exit 1
fi

install_to() {
  local root="$1"
  local dst="${root}/${SKILL_NAME}"
  mkdir -p "${root}"
  rm -rf "${dst}"
  # Also remove legacy uppercase / old names under this root
  rm -rf "${root}/ASS" "${root}/dsc-a" "${root}/dsc-b" "${root}/diagstack-c-comment-style"
  cp -R "${SRC}" "${dst}"
  echo "Installed: ${dst}"
  test -f "${dst}/SKILL.md" || { echo "ERROR: SKILL.md missing at ${dst}" >&2; exit 1; }
}

# Cursor discovers both of these user-level roots
install_to "${HOME}/.cursor/skills"
install_to "${HOME}/.agents/skills"

echo
echo "Verify:"
echo "  ls ~/.cursor/skills/ass/SKILL.md"
echo "  ls ~/.agents/skills/ass/SKILL.md"
echo
echo "Then FULLY quit Cursor and reopen. New chat invoke: @ass  or  ASS  or  A"
