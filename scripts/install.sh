#!/usr/bin/env bash
# Install art (ART) skill to user skill dirs Cursor actually scans.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_NAME="art"
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
  # Old skill name, plus other retired dirs. ART is removed only when it is not dst.
  rm -rf "${root}/ass" "${root}/ASS" "${root}/Ass" \
    "${root}/dsc-a" "${root}/dsc-b" "${root}/diagstack-c-comment-style"
  if [[ -d "${root}/ART" && "${root}/ART" != "${dst}" ]]; then
    rm -rf "${root}/ART"
  fi
  cp -R "${SRC}" "${dst}"
  echo "Installed: ${dst}"
  test -f "${dst}/SKILL.md" || { echo "ERROR: SKILL.md missing at ${dst}" >&2; exit 1; }
  test -f "${dst}/AUTHOR" || { echo "ERROR: AUTHOR missing at ${dst}" >&2; exit 1; }
}

# Cursor discovers both of these user-level roots
install_to "${HOME}/.cursor/skills"
install_to "${HOME}/.agents/skills"

echo
echo "Verify:"
echo "  ls ~/.cursor/skills/art/SKILL.md"
echo "  ls ~/.agents/skills/art/SKILL.md"
echo
echo "Then FULLY quit Cursor and reopen. New chat invoke: @art  or  ART. Rename with ArtStd"
