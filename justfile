set dotenv-load
set shell := ["bash", "-cu"]

plist := "$HOME/Library/LaunchAgents/com.nanoclaw.plist"
service := "com.nanoclaw"
uid := `id -u`
logs_dir := "logs"
db := "store/messages.db"
groups_dir := "groups"

# List available commands
default:
    @just --list

# ── Dev ──────────────────────────────────────────────────────────────────────

[group('dev')]
dev:
    npm run dev

[group('dev')]
build:
    npm run build

[group('dev')]
check:
    npm run typecheck

# ── Code Quality ─────────────────────────────────────────────────────────────

[group('quality')]
lint:
    npm run lint

[group('quality')]
lint-fix:
    npm run lint:fix

[group('quality')]
fmt:
    npm run format

# ── Tests ────────────────────────────────────────────────────────────────────

[group('test')]
test:
    npm run test

[group('test')]
test-watch:
    npm run test:watch

# ── Container ────────────────────────────────────────────────────────────────

[group('container')]
container-build:
    ./container/build.sh

[group('container')]
container-rebuild:
    docker builder prune -f
    ./container/build.sh

# ── Service (macOS launchd) ───────────────────────────────────────────────────

[group('service')]
start:
    launchctl load {{plist}}

[group('service')]
stop:
    launchctl unload {{plist}}

[group('service')]
restart:
    launchctl kickstart -k gui/{{uid}}/{{service}}

[group('service')]
status:
    launchctl list {{service}}

# ── Logs ─────────────────────────────────────────────────────────────────────

[group('logs')]
logs:
    tail -f {{logs_dir}}/nanoclaw.log {{logs_dir}}/nanoclaw.error.log

# ── Database ──────────────────────────────────────────────────────────────────

[group('db')]
migrate:
    npx tsx container/run-migrations.ts

[group('db')]
cleanup:
    ./container/cleanup-sessions.sh
