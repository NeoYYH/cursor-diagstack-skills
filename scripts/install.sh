#!/usr/bin/env bash
# Install ASS skill to ~/.cursor/skills/ASS/
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_ROOT="${HOME}/.cursor/skills"
SKILL_NAME="ASS"
SRC="${REPO_ROOT}/skills/${SKILL_NAME}"
DST="${TARGET_ROOT}/${SKILL_NAME}"

if [[ ! -d "${SRC}" ]]; then
  echo "Skill source not found: ${SRC}" >&2
  exit 1
fi

mkdir -p "${TARGET_ROOT}"
rm -rf "${DST}"
cp -R "${SRC}" "${DST}"
echo "Installed: ${DST}"

# Remove legacy skill dirs
for legacy in dsc-a dsc-b diagstack-c-comment-style ass Ass; do
  if [[ "${legacy}" != "${SKILL_NAME}" ]]; then
    rm -rf "${TARGET_ROOT}/${legacy}"
  fi
done

echo "Restart Cursor or start a new chat."
echo "Invoke (case-insensitive): @ASS | /ASS | ASS | A"
