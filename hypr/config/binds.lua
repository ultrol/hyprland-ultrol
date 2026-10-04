-- Горячие клавиши.
-- Формат: hl.bind("МОДИФИКАТОР + КЛАВИША", действие)
-- Все внешние программы вынесены в ~/.local/bin (vol, powermenu,
-- wallpaper-pick, restart-waybar) — их же можно запускать руками.

local mainMod = "SUPER"
local bin = os.getenv("HOME") .. "/.local/bin/"
local launchPrefix = "uwsm app -- " -- если UWSM не используется, поставьте ""

-- Клавиши-цифры на AZERTY: символы не совпадают, ловим по коду клавиши.
-- Цифра d -> evdev keycode: 1..9 => 10..18, 0 => 19
local function digitCode(d)
    return "code:" .. (d == 0 and 19 or (9 + d))
end

---------------------------
---- УПРАВЛЕНИЕ ОКНАМИ ----
---------------------------

hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("powermenuё"))
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))

-- Фокус
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())

-- Перенос окон между воркспейсами и мониторами
hl.bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(1),     hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(2),     hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(3),     hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(4),     hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(5),     hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(6),     hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(7),     hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(8),     hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(9),     hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + " .. digitCode(10),     hl.dsp.window.move({ workspace = "10" }))
hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i }))
end
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + ALT + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i, follow = false }))
end

-- Перетаскивание и изменение размера мышью
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Зум экрана
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + Plus",  function() zoomfunction(0.3) end,  { repeating = true })
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end,  { repeating = true })

-------------------
---- ЗАПУСК ОКНА ----
-------------------

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind("XF86Calculator",           hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))

------------------------
---- ЛАУНЧЕР И UI ----
------------------------

hl.bind(mainMod .. " + Space",     hl.dsp.exec_cmd("rofi -show drun"))     -- приложения
hl.bind(mainMod .. " + Tab",       hl.dsp.focus({ workspace = "m+1" }))    -- следующий рабочий стол
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("hyprlock"))             -- блокировка (только вручную)
hl.bind(mainMod .. " + X",         hl.dsp.exec_cmd("pavucontrol"))          -- звук
hl.bind(mainMod .. " + ALT + C",   hl.dsp.exec_cmd(bin .. "powermenu"))            -- выключение/перезагрузка
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(bin .. "wallpaper-pick"))       -- обои + перекраска системы
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd('cliphist list | rofi -dmenu -i -p "буфер" | cliphist decode | wl-copy'))
hl.bind(mainMod .. " + A",         hl.dsp.exec_cmd("makoctl history-pop"))  -- история уведомлений

---------------------------
---- АППАРАТНЫЕ КЛАВИШИ ----
---------------------------

-- Звук (скрипт vol показывает уведомление вместо OSD)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(bin .. "vol up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(bin .. "vol down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(bin .. "vol mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(bin .. "vol mic"),  { locked = true })

-- Музыка
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Яркость (на десктопе без регулируемой подсветки просто ничего не делает)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5% 2>/dev/null || true"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- 2>/dev/null || true"), { locked = true, repeating = true })

--------------------
---- УТИЛИТЫ ----
--------------------

-- Скриншоты: Print — меню режима (область/окно/экран), Super+Print — весь экран сразу
hl.bind("Print",               hl.dsp.exec_cmd(bin .. "screenshot"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m output -z"))

-- Пипетка цветов
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a -n"))

-------------------------------
---- ВОРКСПЕЙСЫ И МОНИТОРЫ ----
-------------------------------

-- Переключение рабочих столов: Super+1..9,0
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. digitCode(key), hl.dsp.focus({ workspace = i }))
end

-- Фокус на воркспейс относительный монитора
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + CONTROL + " .. digitCode(key), hl.dsp.focus({ workspace = "m~" .. i }))
end

-- Соседние воркспейсы и следующий пустой
hl.bind(mainMod .. " + CONTROL + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Down",  hl.dsp.focus({ workspace = "emptym" }))

-- Кручение воркспейсов и мониторов колесом
hl.bind(mainMod .. " + mouse_down",         hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_up",           hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + mouse_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

