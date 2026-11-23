#!/usr/bin/env bash
set -euo pipefail

SCOPE="${1:-user}"
EDITION="${2:-auto}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/skills/modern-web-guidance"

if [ ! -f "$SOURCE/SKILL.md" ]; then
  echo "[ERROR] Source skill not found: $SOURCE/SKILL.md" >&2
  exit 1
fi

case "$SCOPE" in
  user|project) ;;
  *)
    echo "Usage: $0 [user|project] [auto|domestic|international|both]" >&2
    exit 2
    ;;
esac

case "$EDITION" in
  auto|domestic|international|both) ;;
  *)
    echo "Usage: $0 [user|project] [auto|domestic|international|both]" >&2
    exit 2
    ;;
esac

DOMESTIC="${HOME}/.workbuddy/skills"
INTERNATIONAL="${HOME}/.workbuddy-ai/skills"

ROOTS=()
if [ "$SCOPE" = "project" ]; then
  ROOTS+=("${PWD}/.codebuddy/skills")
else
  case "$EDITION" in
    domestic) ROOTS+=("$DOMESTIC") ;;
    international) ROOTS+=("$INTERNATIONAL") ;;
    both) ROOTS+=("$DOMESTIC" "$INTERNATIONAL") ;;
    auto)
      [ -d "$(dirname "$DOMESTIC")" ] && ROOTS+=("$DOMESTIC")
      [ -d "$(dirname "$INTERNATIONAL")" ] && ROOTS+=("$INTERNATIONAL")
      [ "${#ROOTS[@]}" -eq 0 ] && ROOTS+=("$DOMESTIC")
      ;;
  esac
fi

for SKILLS_ROOT in "${ROOTS[@]}"; do
  DESTINATION="$SKILLS_ROOT/modern-web-guidance"
  mkdir -p "$SKILLS_ROOT"

  if [ -e "$DESTINATION" ]; then
    STAMP="$(date +%Y%m%d-%H%M%S)"
    BACKUP="${DESTINATION}.backup-${STAMP}"
    mv "$DESTINATION" "$BACKUP"
    echo "[INFO] Existing skill backed up to: $BACKUP"
  fi

  cp -R "$SOURCE" "$DESTINATION"

  if [ ! -f "$DESTINATION/SKILL.md" ]; then
    echo "[ERROR] Installation verification failed: SKILL.md missing at $DESTINATION" >&2
    exit 1
  fi

  echo "[OK] Installed WorkBuddy skill to: $DESTINATION"
done

echo "[OK] Scope: $SCOPE"
echo "[OK] Edition: $EDITION"
echo "[OK] Target count: ${#ROOTS[@]}"
echo "Next: fully restart WorkBuddy, then open a new session."
