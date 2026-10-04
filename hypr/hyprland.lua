-- Точка входа конфигурации Hyprland.
-- Порядок: цвета → настройки → мониторы/ввод → вид → запуск → клавиши → правила.
-- Каждый файл ниже отвечает за одну тему — правится отдельно.

require("config.colors")        -- палитра (генерируется rice)
require("config.variables")     -- приложения, мониторы, число воркспейсов
require("config.environment")   -- переменные окружения
require("config.monitors")      -- мониторы
require("config.inputs")        -- ввод: клавиатура, мышь, жесты
require("config.decorations")   -- gaps, скругления, прозрачность, blur
require("config.animations")    -- анимации и bezier-кривые
require("config.autostart")     -- что запускать при старте сессии
require("config.binds")         -- горячие клавиши
require("config.misc")          -- разное (dwindle, splash, xwayland)
require("config.windowrules")   -- правила окон и слоёв
require("config.workspaces")    -- правила воркспейсов
