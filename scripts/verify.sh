#!/usr/bin/env bash
set -euo pipefail

SCOPE="${1:-user}"
EDITION="${2:-auto}"

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

INSTALLED=0
for SKILLS_ROOT in "${ROOTS[@]}"; do
  DESTINATION="$SKILLS_ROOT/modern-web-guidance"
  SKILL_MD="$DESTINATION/SKILL.md"

  [ -f "$SKILL_MD" ] || continue

  grep -Eq '^name:[[:space:]]*modern-web-guidance[[:space:]]*$' "$SKILL_MD" || {
    echo "[ERROR] Invalid SKILL.md at $SKILL_MD: missing or incorrect name field" >&2
    exit 1
  }

  grep -Eq '^agent_created:[[:space:]]*true[[:space:]]*$' "$SKILL_MD" || {
    echo "[ERROR] Invalid SKILL.md at $SKILL_MD: missing agent_created: true" >&2
    exit 1
  }

  GUIDE_COUNT="$(find "$DESTINATION/guides" -type f -name '*.md' | wc -l | tr -d ' ')"
  if [ "$GUIDE_COUNT" -lt 50 ]; then
    echo "[ERROR] Guide corpus looks incomplete at $DESTINATION: only $GUIDE_COUNT markdown files found" >&2
    exit 1
  fi

  echo "[OK] Skill directory: $DESTINATION"
  echo "[OK] SKILL.md metadata"
  echo "[OK] Guide files: $GUIDE_COUNT"
  INSTALLED=$((INSTALLED + 1))
done

if [ "$INSTALLED" -eq 0 ]; then
  echo "[ERROR] Skill not installed in any expected target. Run install.sh first." >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "[ERROR] Node.js not found" >&2
  exit 1
fi
echo "[OK] Node.js: $(node --version)"

echo "[INFO] Running CLI search smoke test..."
npx -y modern-web-guidance@latest search "dialog light dismiss" >/dev/null

echo "[OK] Verified targets: $INSTALLED"
echo "[OK] CLI search succeeded"
echo "[OK] WorkBuddy skill installation verified"
