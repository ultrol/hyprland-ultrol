#!/usr/bin/env bash
#
#  hyprland-ultrol — установка риса на чистую Arch Linux / CachyOS
#
#  Одна команда:
#    curl -fsSL https://raw.githubusercontent.com/ultrol/hyprland-ultrol/main/install.sh | bash
#
#  Переменные окружения (необязательные):
#    DOTFILES_DIR=/path   — куда клонировать репозиторий (по умолчанию ~/dotfiles)
#    SKIP_PACKAGES=1      — не трогать пакеты (только разложить конфиги)
#    SKIP_SERVICES=1      — не включать NetworkManager/bluetooth
#
set -euo pipefail

REPO_URL="https://github.com/ultrol/hyprland-ultrol.git"
REPO_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SKIP_PACKAGES="${SKIP_PACKAGES:-0}"
SKIP_SERVICES="${SKIP_SERVICES:-0}"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mx\033[0m %s\n' "$*" >&2; exit 1; }

# ── 0. Проверки ──────────────────────────────────────────────────────────────
[ "$(id -u)" -eq 0 ] && die "запускай от обычного пользователя, не от root"
command -v pacman >/dev/null 2>&1 || die "нужна Arch Linux или CachyOS (pacman не найден)"
command -v sudo   >/dev/null 2>&1 || die "не найден sudo"

# Скрипт может запускаться из уже склонированного репозитория:
# если рядом лежат галочки риса — используем эту папку, повторно не клонируем.
SELF="${BASH_SOURCE[0]:-}"
if [ -n "$SELF" ] && [ -f "$SELF" ]; then
    SELF_DIR="$(cd "$(dirname "$SELF")" && pwd)"
    if [ -f "$SELF_DIR/hypr/hyprland.lua" ] && [ -d "$SELF_DIR/bin" ]; then
        REPO_DIR="$SELF_DIR"
    fi
fi

# ── 1. Пакеты ───────────────────────────────────────────────────────────────
if [ "$SKIP_PACKAGES" != 1 ]; then
    OFFICIAL=(
        # compositor + сессия
        hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
        uwsm hypridle hyprlock hyprshot hyprpicker polkit-gnome
        # панель, лаунчер, уведомления, буфер обмена
        waybar rofi mako wl-clipboard cliphist
        # терминалы и редакторы
        kitty alacritty btop fish neovim micro
        # приложения
        dolphin firefox gnome-text-editor gnome-calculator pavucontrol
        # демоны и утилиты
        networkmanager bluez bluez-utils pipewire pipewire-pulse wireplumber
        brightnessctl playerctl libnotify imagemagick awww jq git pciutils
        xdg-user-dirs desktop-file-utils
        # темы, шрифты, тулкиты
        adwaita-icon-theme adwaita-cursors adwaita-fonts adw-gtk-theme
        nwg-look qt6ct xsettingsd
        ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols noto-fonts-emoji
        # для сборки yay
        base-devel
    )
    AUR_MUST=(gowall waybar-module-pacman-updates-git bibata-cursor-theme-bin)
    AUR_OPT=(qview swash)

    log "Обновляю базу пакетов и ставлю официальные пакеты (${#OFFICIAL[@]} шт.)"
    sudo pacman -Syu --needed --noconfirm "${OFFICIAL[@]}"

    # ── yay для AUR ──
    if ! command -v yay >/dev/null 2>&1; then
        log "Ставлю yay (AUR-помощник)"
        tmp="$(mktemp -d)"
        git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
        (cd "$tmp/yay-bin" && makepkg -si --noconfirm --needed)
        rm -rf "$tmp"
    fi
    command -v yay >/dev/null 2>&1 || die "yay не установился — поставь его вручную и перезапусти"

    log "Ставлю пакеты из AUR: ${AUR_MUST[*]}"
    yay -S --needed --noconfirm "${AUR_MUST[@]}"
    log "Опциональные пакеты из AUR: ${AUR_OPT[*]}"
    yay -S --needed --noconfirm "${AUR_OPT[@]}" || warn "часть опциональных пакетов не установилась (не критично)"
else
    log "SKIP_PACKAGES=1 — пакеты не трогаю"
fi

# ── 2. Репозиторий ──────────────────────────────────────────────────────────
if [ ! -d "$REPO_DIR/.git" ]; then
    log "Клонирую $REPO_URL → $REPO_DIR"
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "$REPO_URL" "$REPO_DIR"
else
    log "Репозиторий уже есть: $REPO_DIR"
fi
[ -d "$REPO_DIR/hypr" ] || die "$REPO_DIR не похож на репозиторий риса"

# ── 3. Аппаратная правка: NVIDIA ────────────────────────────────────────────
# В конфигах включены NVIDIA-переменные. Без проприетарного драйвера они
# ломают запуск Hyprland, поэтому на машинах без nvidia-драйвера их выключаем.
nvidia_driver_loaded() {
    command -v nvidia-smi >/dev/null 2>&1 && return 0
    [ -r /proc/driver/nvidia/version ] && return 0
    return 1
}

if nvidia_driver_loaded; then
    log "NVIDIA-драйвер найден — конфиги не трогаю"
else
    log "NVIDIA-драйвера нет — выключаю NVIDIA-переменные в конфигах"
    sed -i 's/^\(export GBM_BACKEND=nvidia-drm\)$/# \1/' "$REPO_DIR/uwsm/env" 2>/dev/null || true
    sed -i \
        -e 's/^hl\.env("GBM_BACKEND"/-- hl.env("GBM_BACKEND"/' \
        -e 's/^hl\.env("__GLX_VENDOR_LIBRARY_NAME"/-- hl.env("__GLX_VENDOR_LIBRARY_NAME"/' \
        -e 's/^hl\.env("LIBVA_DRIVER_NAME"/-- hl.env("LIBVA_DRIVER_NAME"/' \
        "$REPO_DIR/hypr/config/environment.lua" 2>/dev/null || true
    warn "если видеокарта всё-таки NVIDIA — раскомментируй строки обратно (см. README)"
fi

# ── 4. Раскладка конфигов (с бэкапом) ───────────────────────────────────────
CONFIG_ITEMS=(
    hypr waybar rofi kitty mako btop alacritty fish nvim micro menus
    gtk-3.0 gtk-4.0 nwg-look xsettingsd qView gowall swash uwsm qt6ct
    kdeglobals dolphinrc mimeapps.list pavucontrol.ini baloofileinformationrc
)
HOME_ITEMS=(.bashrc .bash_profile .zshrc .gtkrc-2.0)

backup_move() { # $1 = путь, который надо убрать в бэкап
    mkdir -p "$BACKUP_DIR"
    mv "$1" "$BACKUP_DIR/$(basename "$1")"
    log "бэкап: $1 → $BACKUP_DIR/"
}

link_item() { # $1 = имя, $2 = откуда, $3 = куда
    local name="$1" src="$2" dst="$3"
    [ -e "$src" ] || { warn "в репозитории нет $name — пропускаю"; return 0; }
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return 0                                    # уже подключено
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        backup_move "$dst"
    fi
    ln -s "$src" "$dst"
}

log "Подключаю конфиги из репозитория (существующие уйдут в бэкап)"
mkdir -p "$HOME/.config"
for name in "${CONFIG_ITEMS[@]}"; do
    link_item "$name" "$REPO_DIR/$name" "$HOME/.config/$name"
done

log "Подключаю дотфайлы домашней директории"
for name in "${HOME_ITEMS[@]}"; do
    link_item "$name" "$REPO_DIR/home/$name" "$HOME/$name"
done

# ── 5. Скрипты ──────────────────────────────────────────────────────────────
log "Подключаю скрипты в ~/.local/bin"
mkdir -p "$HOME/.local/bin"
for f in "$REPO_DIR"/bin/*; do
    link_item "$(basename "$f")" "$f" "$HOME/.local/bin/$(basename "$f")"
    chmod +x "$f"
done

# ── 6. Обои ─────────────────────────────────────────────────────────────────
# rice и wallpaper-pick ждут картинки в ~/Pictures/wallpapers
if [ -L "$HOME/Pictures/wallpapers" ] && [ "$(readlink "$HOME/Pictures/wallpapers")" = "$REPO_DIR/wallpapers" ]; then
    :
elif [ -e "$HOME/Pictures/wallpapers" ]; then
    warn "~/Pictures/wallpapers уже существует и это не ссылка на репозиторий — оставляю как есть"
else
    log "Обои: ~/Pictures/wallpapers → $REPO_DIR/wallpapers"
    mkdir -p "$HOME/Pictures"
    ln -s "$REPO_DIR/wallpapers" "$HOME/Pictures/wallpapers"
fi

# ── 7. Службы ───────────────────────────────────────────────────────────────
if [ "$SKIP_SERVICES" != 1 ]; then
    log "Включаю NetworkManager и bluetooth"
    sudo systemctl enable --now NetworkManager.service 2>/dev/null || warn "NetworkManager не включился"
    sudo systemctl enable --now bluetooth.service 2>/dev/null      || warn "bluetooth не включился (на десктопе без адаптера это нормально)"
fi

# ── 8. Итог ─────────────────────────────────────────────────────────────────
cat <<EOF

Готово. Репозиторий: $REPO_DIR
Бэкап старых конфигов: $([ -d "$BACKUP_DIR" ] && echo "$BACKUP_DIR" || echo "не потребовался")

Что дальше:

  1) Войти в сессию (дисплей-менеджер по умолчанию не ставится):
       из TTY:      exec uwsm start -e -D Hyprland hyprland.desktop
       или GDM:     sudo pacman -S gdm && sudo systemctl enable --default gdm
                     (в списке сессий выбирай «Hyprland (uwsm-managed)»)

  2) Подогнать монитор: отредактировать $REPO_DIR/hypr/config/monitors.lua
     (по умолчанию 2560x1440@240) и $REPO_DIR/hypr/config/variables.lua

  3) Сделать fish оболочкой по умолчанию (конфиг уже подключён):
       chsh -s /usr/bin/fish

  4) Перекрасить систему под обои:
       rice ~/Pictures/wallpapers/<файл>

EOF
