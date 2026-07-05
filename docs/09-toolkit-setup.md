# 09 - Инструментарий: установка

Конкретный набор публичных инструментов, ускоряющих сборку сайта с AI-агентом (Claude Code). Все команды сверены с официальными репозиториями. Категории и логику «зачем» - см. [`08-skills-and-tools.md`](08-skills-and-tools.md).

> ⚠️ Всё ниже - **сторонний код**, исполняется на твоей машине. Ставь осознанно, при желании просмотри исходники. Ссылки на официальные источники приведены у каждого пункта.

## Быстро - одним скриптом

```bash
# из корня репозитория website-blueprint
bash scripts/setup-tools.sh          # интерактивно, спрашивает про каждый
bash scripts/setup-tools.sh --yes    # без вопросов (кроме тех, что требуют ключ)
```

Скрипт проверит зависимости (`claude`, `node`, `npx`), поставит то, что ставится без ключа, и напечатает инструкции для остального. Полностью прозрачен - каждый шаг виден.

## Что ставится и зачем

| Инструмент | Тип | Зачем | Ключ |
|---|---|---|---|
| **Context7** | MCP | Свежая документация фреймворков прямо в контексте агента - меньше галлюцинаций по API | нет (опц. для лимитов) |
| **Magic UI** | MCP | Анимационные компоненты для лендингов (Marquee, Number Ticker и др.) | нет |
| **ui-ux-pro-max** | скилл | Советник: стиль, палитра, пары шрифтов, UX-правила под тип продукта | нет |
| **Magic (21st.dev)** | MCP | Генерация UI-компонентов по текстовому описанию | **да** |
| **shadcn/ui** | CLI (per-project) | Готовые компоненты + Tailwind в конкретном проекте | нет |

## Команды вручную

### Общий синтаксис MCP в Claude Code
```bash
claude mcp add --transport stdio --scope user <name> -- <command>   # локальный, глобально
claude mcp add --transport http  --scope user <name> <url> --header "KEY: VALUE"  # remote
claude mcp list                                                     # проверить
```
`--scope user` = глобально для всех твоих проектов. MCP-сервер - это процесс с инструментами; скилл - это папка `~/.claude/skills/<name>/` с инструкциями (не процесс).

### Context7 (MCP, без ключа)
Источник: https://github.com/upstash/context7
```bash
claude mcp add --transport stdio --scope user context7 -- npx -y @upstash/context7-mcp
```
Опционально с ключом (выше лимиты, бесплатно на context7.com/dashboard):
```bash
claude mcp add --transport http --scope user context7 https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: ВАШ_КЛЮЧ"
```

### Magic UI (MCP, без ключа)
Источник: https://github.com/magicuidesign/mcp
```bash
npx @magicuidesign/cli@latest install claude
```

### ui-ux-pro-max (скилл, нужен Python 3)
Источник: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
```bash
npm install -g ui-ux-pro-max-cli
uipro init --ai claude --global      # в ~/.claude/skills/ ; без --global - в текущий проект
```
> **Оговорка:** у GitHub-репозитория аномально раздутая статистика звёзд (похоже на накрутку) - **не считай её сигналом качества**. Сам npm-пакет рабочий (MIT, реальные загрузки) и требует Python 3 для скрипта поиска. Просмотри перед установкой, если параноишь (правильно параноишь).

### Magic от 21st.dev (MCP, нужен API-ключ)
Источник: https://github.com/21st-dev/magic-mcp · сервис в статусе Beta, пишет файлы компонентов.
```bash
# ключ: https://21st.dev/magic/console
npx @21st-dev/cli@latest install claude --api-key ВАШ_КЛЮЧ
```

### shadcn/ui (per-project)
Имя пакета - `shadcn` (не устаревший `shadcn-ui`). Запускать в папке проекта:
```bash
npx shadcn@latest init        # или: pnpm dlx shadcn@latest init
```

## Встроено в Claude Code (ставить не надо)

- `frontend-design` - генерация distinctive-фронтенда.
- `/code-review` - ревью изменений.
- `/security-review` - security-обзор перед сдачей.

## Минимальный набор

Если не хочешь ставить всё - для 90% пользы достаточно **Context7** (свежие доки) + **ui-ux-pro-max** (дизайн-советник). Остальное - по вкусу.
