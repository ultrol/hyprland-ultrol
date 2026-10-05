# hyprland-ultrol

Райс для Hyprland на Arch Linux / CachyOS: Lua-конфиги, панель waybar,
уведомления mako, лаунчер rofi, блокировка hyprlock и скрипт **`rice`** —
перекраска всей системы (панель, окна, терминалы, GTK, KDE) под палитру выбранных обоев.

- **Compositor:** Hyprland (конфиг на Lua, нужен Hyprland ≥ 0.56)
- **Сессия:** UWSM (systemd-интеграция), автозагрузка через `hyprland.start`
- **Оболочка:** fish (настроена), работают также zsh и bash
- **Пакеты:** официальные репозитории Arch + 3 пакета из AUR

---

## Установка одной командой

На чистой Arch Linux или CachyOS, от обычного пользователя (не от root):

```bash
curl -fsSL https://raw.githubusercontent.com/ultrol/hyprland-ultrol/main/install.sh | bash
```

Скрипт сделает всё сам:

1. обновит систему и установит пакеты (`pacman`);
2. соберёт и поставит **yay**, затем пакеты из AUR
   (`gowall`, `waybar-module-pacman-updates-git`, `bibata-cursor-theme-bin`,
   опционально `qview` и `swash`);
3. склонирует репозиторий в `~/dotfiles`;
4. **с бэкапом** подключит конфиги из репозитория симлинками в `~/.config/*`,
   `~/.local/bin/*` и домашние дотфайлы (`.bashrc`, `.zshrc`, `.bash_profile`, `.gtkrc-2.0`);
   всё заменённое попадёт в `~/.dotfiles-backup-<дата>/`;
5. свяжет `~/Pictures/wallpapers` с папкой обоев из репозитория;
6. включит NetworkManager и bluetooth;
7. **отключит NVIDIA-переменные**, если проприетарного драйвера нет
   (иначе Hyprland не стартует).

Переменные окружения для тонкой настройки:

| Переменная | Значение |
|---|---|
| `DOTFILES_DIR=/path` | куда клонировать репозиторий (по умолчанию `~/dotfiles`) |
| `SKIP_PACKAGES=1` | не трогать пакеты, только разложить конфиги |
| `SKIP_SERVICES=1` | не включать NetworkManager/bluetooth |

Пример: `DOTFILES_DIR=~/hyprland-ultrol SKIP_SERVICES=1 bash install.sh`

### После установки

1. **Войти в сессию.** Дисплей-менеджер по умолчанию не ставится, поэтому:
   - из TTY: `exec uwsm start -e -D Hyprland hyprland.desktop`
   - или поставить GDM: `sudo pacman -S gdm && sudo systemctl enable --default gdm`,
     в списке сессий выбрать **«Hyprland (uwsm-managed)»**
2. **Монитор.** В `hypr/config/monitors.lua` зашит режим `2560x1440@240` —
   подогните под свой экран (имена мониторов: `hyprctl monitors`).
3. **Оболочка:** `chsh -s /usr/bin/fish`
4. **Обои и перекраска:** `rice ~/Pictures/wallpapers/<файл>`

---

## Структура репозитория

| Путь | Что это | Куда ставится |
|---|---|---|
| `hypr/` | конфиг Hyprland на Lua (`hyprland.lua` + `config/*.lua`) | `~/.config/hypr` |
| `hypr/config/colors.lua` | **GENERATED** — палитра от `rice` | там же |
| `waybar/` | панель: `config.jsonc`, `style.css`, `colors.css` | `~/.config/waybar` |
| `mako/` | уведомления | `~/.config/mako` |
| `rofi/` | лаунчер и меню | `~/.config/rofi` |
| `kitty/`, `alacritty/` | терминалы | `~/.config/…` |
| `btop/`, `nvim/`, `micro/` | мониторинг и редакторы | `~/.config/…` |
| `fish/` | оболочка fish | `~/.config/fish` |
| `gtk-3.0/`, `gtk-4.0/`, `nwg-look/`, `xsettingsd/` | GTK-темы и курсоры | `~/.config/…` |
| `kdeglobals`, `dolphinrc`, `mimeapps.list` | KDE/Dolphin: тема, ассоциации | `~/.config/…` |
| `qt6ct/`, `uwsm/` | Qt-тулкит, переменные сессии UWSM | `~/.config/…` |
| `menus/`, `pavucontrol.ini`, `qView/`, `gowall/`, `swash/`, `baloofileinformationrc` | мелкие конфиги приложений | `~/.config/…` |
| `bin/` | скрипты: `rice`, `powermenu`, `screenshot`, `vol`, `wallpaper-pick`, `restart-waybar` | `~/.local/bin` |
| `home/` | дотфайлы: `.bashrc`, `.bash_profile`, `.zshrc`, `.gtkrc-2.0` | `~/` |
| `wallpapers/` | 13 обоев | `~/Pictures/wallpapers` |
| `install.sh` | установщик | — |

Файлы с пометкой **GENERATED** (`hypr/config/colors.lua`, `hypr/hyprlock.colors.conf`,
`waybar/colors.css`, `kitty/colors.conf`, `kdeglobals` и др.) перезаписываются
скриптом `rice` при каждом запуске — править их руками бессмысленно.

---

## Горячие клавиши

`Super` — основной модификатор. Цифры заданы по коду клавиши (AZERTY совместимы).

### Окна

| Клавиша | Действие |
|---|---|
| `Super + Q` | закрыть окно |
| `Super + F` / `Super + Shift + F` | полноэкранный режим / gerçek full |
| `Super + Alt + Space` | плавающее окно |
| `Super + J` | переключить layout (split) |
| `Super + ←/→/↑/↓` | фокус по направлению |
| `Alt + Tab` | следующее окно |
| `Super + Shift + ←/→/↑/↓` | перенести окно по направлению |
| `Super + Shift + 1…0` | перенести окно на воркспейс |
| `Super + LMB` / `Super + RMB` | перетащить / изменить размер |
| `Super + −` / `Super + +` | зум экрана |

### Запуск

| Клавиша | Действие |
|---|---|
| `Super + Return` | терминал (kitty) |
| `Super + E` | файловый менеджер (Dolphin) |
| `Super + T` | редактор (gnome-text-editor) |
| `Super + C` | калькулятор |
| `Super + W` | браузер (Firefox) |
| `Ctrl + Shift + Escape` | btop в терминале |

### Лаунчер и UI

| Клавиша | Действие |
|---|---|
| `Super + Space` | rofi — приложения |
| `Super + Tab` | следующий рабочий стол |
| `Super + V` | история буфера обмена (cliphist + rofi) |
| `Super + A` | история уведомлений |
| `Super + L` | заблокировать (hyprlock) |
| `Super + X` | громкость (pavucontrol) |
| `Super + Escape` | меню питания |
| `Super + Alt + C` | меню питания (дубль) |
| `Super + Shift + W` | выбор обоев + перекраска системы |

### Рабочие столы и мониторы

| Клавиша | Действие |
|---|---|
| `Super + 1…0` | переключиться на воркспейс |
| `Super + Ctrl + 1…0` | воркспейс относительно монитора |
| `Super + Ctrl + ←/→` | соседний воркспейс |
| `Super + Ctrl + ↓` | ближайший пустой воркспейс |
| `Super + Tab`, колесо | пролистывание воркспейсов |
| `Super + Shift + колесо` | перенести окно на соседний монитор |

### Медиа и утилиты

| Клавиша | Действие |
|---|---|
| `Print` | скриншот с выбором режима (область/окно/экран) |
| `Super + Print` | скриншот всего экрана |
| `Super + P` | пипетка цвета (hyprpicker) |
| `XF86Audio…` | громкость, мут, микрофон, плеер (`vol`, `playerctl`) |
| `XF86MonBrightness…` | яркость (`brightnessctl`, на десктопе без подсветки не делает ничего) |

---

## Перекраска под обои: `rice`

```bash
rice ~/Pictures/wallpapers/004\ -\ makima.jpg
```

Что делает: ставит обои через `awww`, вытаскивает палитру через `gowall extract`
и генерирует цвета для waybar, Hyprland, mako, rofi, hyprlock, kitty, btop,
alacritty, GTK и KDE, затем перезагружает всё на лету.

Запуск вручную или через `Super + Shift + W` (`wallpaper-pick` — выбор из
`~/Pictures/wallpapers` через rofi).

Зависимости: `awww`, `gowall` (AUR), `imagemagick`, `hyprctl`, `makoctl` —
все ставятся `install.sh`.

---

## Ручная установка

Если не хочется одним скриптом:

```bash
# 1. пакеты
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  uwsm hypridle hyprlock hyprshot hyprpicker polkit-gnome \
  waybar rofi mako wl-clipboard cliphist kitty alacritty btop fish neovim micro \
  dolphin firefox gnome-text-editor gnome-calculator pavucontrol \
  networkmanager bluez bluez-utils pipewire pipewire-pulse wireplumber \
  brightnessctl playerctl libnotify imagemagick awww jq git pciutils \
  adwaita-icon-theme adwaita-cursors adwaita-fonts adw-gtk-theme \
  nwg-look qt6ct xsettingsd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols noto-fonts-emoji base-devel

# 2. AUR (yay: git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si)
yay -S gowall waybar-module-pacman-updates-git bibata-cursor-theme-bin qview swash

# 3. конфиги
git clone https://github.com/ultrol/hyprland-ultrol.git ~/dotfiles
ln -s ~/dotfiles/hypr     ~/.config/hypr
ln -s ~/dotfiles/waybar   ~/.config/waybar
# …остальные каталоги аналогично
mkdir -p ~/.local/bin && ln -s ~/dotfiles/bin/* ~/.local/bin/
mkdir -p ~/Pictures && ln -s ~/dotfiles/wallpapers ~/Pictures/wallpapers

# 4. службы
sudo systemctl enable --now NetworkManager bluetooth
```

---

## Важные нюансы

**NVIDIA.** В `uwsm/env` и `hypr/config/environment.lua` включены
`GBM_BACKEND=nvidia-drm`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`,
`LIBVA_DRIVER_NAME=nvidia`. На машине с проприетарным драйвером ничего менять
не нужно. Если драйвера нет (AMD/Intel либо nouveau) — `install.sh` закомментирует
эти строки сам; при ручной установке сделайте это вручную, иначе чёрный экран.

**Мониторы.** `hypr/config/monitors.lua` по умолчанию задаёт `2560x1440@240` для
монитора с пустым именем (любой подключённый). Имена и режимы: `hyprctl monitors`.

**UWSM.** Все приложения запускаются через `uwsm app -- …` (переменная
`launchPrefix` в `hypr/config/binds.lua`). Без сессии UWSM поставь
`launchPrefix = ""`. Если UWSM не используется, переменные перенеси в
`hypr/config/environment.lua`.

**Персональные настройки.** `variables.lua` (терминал, файловый менеджер,
браузер, число воркспейсов) и `monitors.lua` — главные места для правки.

**Обновление риса:**

```bash
cd ~/dotfiles && git pull
```

Симлинки останутся на месте, изменения подхватятся сразу
(`hyprctl reload` или перелогин для Hyprland).
