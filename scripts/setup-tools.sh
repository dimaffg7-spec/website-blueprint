#!/usr/bin/env bash
#
# Website Blueprint - установка рекомендуемого инструментария для сборки сайтов.
#
# Ставит СТОРОННИЙ код (MCP-серверы и дизайн-скилл) на твою машину.
# Скрипт прозрачный: печатает каждый шаг и по умолчанию спрашивает согласие.
# Флаг --yes ставит всё без вопросов (кроме того, что требует API-ключ).
#
# Источники и оговорки по безопасности - в docs/09-toolkit-setup.md.
# Запуск:  bash scripts/setup-tools.sh        (интерактивно)
#          bash scripts/setup-tools.sh --yes  (без вопросов)

AUTO=false
[ "${1:-}" = "--yes" ] && AUTO=true

confirm() {
  $AUTO && return 0
  printf "  → Ставим: %s ? [y/N] " "$1"
  read -r a
  [ "$a" = "y" ] || [ "$a" = "Y" ]
}

echo "=================================================="
echo " Website Blueprint - рекомендуемый инструментарий"
echo "=================================================="
echo "Внимание: ставится сторонний код (npx-пакеты, скилл)."
echo "Все инструменты официальные, ссылки - в docs/09-toolkit-setup.md."
echo

# --- Проверка зависимостей ---
missing=""
command -v claude >/dev/null 2>&1 || missing="$missing claude"
command -v node   >/dev/null 2>&1 || missing="$missing node"
command -v npx    >/dev/null 2>&1 || missing="$missing npx"
if [ -n "$missing" ]; then
  echo "✗ Не хватает:$missing"
  echo "  Установи Claude Code CLI и Node.js, потом запусти снова."
  exit 1
fi
echo "✓ Зависимости на месте (claude, node, npx)"
echo

# --- 1. Context7 (свежая документация библиотек, MCP; без API-ключа) ---
if confirm "Context7 - свежие доки фреймворков в контексте агента (MCP)"; then
  claude mcp add --transport stdio --scope user context7 -- npx -y @upstash/context7-mcp \
    && echo "  ✓ Context7 добавлен (глобально)" \
    || echo "  ! Context7: возможно уже добавлен или ошибка - проверь 'claude mcp list'"
fi
echo

# --- 2. Magic UI (анимации для лендингов, MCP; без API-ключа) ---
if confirm "Magic UI - анимационные компоненты лендингов (MCP)"; then
  npx @magicuidesign/cli@latest install claude \
    && echo "  ✓ Magic UI установлен" \
    || echo "  ! Magic UI: ошибка установки - см. docs/09"
fi
echo

# --- 3. ui-ux-pro-max (дизайн-советник, скилл; нужен Python 3) ---
if confirm "ui-ux-pro-max - советник по стилю/палитре/шрифтам (скилл; нужен Python 3)"; then
  if command -v python3 >/dev/null 2>&1; then
    npm install -g ui-ux-pro-max-cli \
      && uipro init --ai claude --global \
      && echo "  ✓ ui-ux-pro-max установлен (~/.claude/skills/)" \
      || echo "  ! ui-ux-pro-max: ошибка - см. docs/09"
  else
    echo "  ✗ Пропущено: нет python3 (скилл его требует)"
  fi
fi
echo

# --- Требуют API-ключ: авто не ставим, печатаем инструкцию ---
echo "--------------------------------------------------"
echo "Требуют API-ключ (поставь вручную, когда получишь ключ):"
echo
echo "  Magic (21st.dev) - генерация UI-компонентов по описанию:"
echo "    1) получи ключ: https://21st.dev/magic/console"
echo "    2) npx @21st-dev/cli@latest install claude --api-key ВАШ_КЛЮЧ"
echo

# --- Per-project: не глобально, а в папке конкретного сайта ---
echo "--------------------------------------------------"
echo "Per-project (запускать В ПАПКЕ сайта, не глобально):"
echo
echo "  shadcn/ui - компоненты + Tailwind:"
echo "    npx shadcn@latest init"
echo

echo "=================================================="
echo "Готово. Проверить MCP-серверы:  claude mcp list"
echo "Дизайн-скилл ui-ux-pro-max доступен в новом чате Claude Code."
echo "=================================================="
