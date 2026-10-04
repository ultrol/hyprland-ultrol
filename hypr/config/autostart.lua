-- Автозагрузка — всё, что стартует вместе со сессией.
-- Вики: https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Переменные сессии для systemd/dbus (нужно для polkit, xdg и т.п.)
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")

    -- Панель (конфиг: ~/.config/waybar, перезапуск: restart-waybar)
    hl.exec_cmd("waybar")

    -- Уведомления (конфиг: ~/.config/mako/config)
    hl.exec_cmd("mako")

    -- Автоблокировка и погашение экрана (конфиг: ~/.config/hypr/hypridle.conf)
    hl.exec_cmd("hypridle")

    -- Обои: поднимаем демон и показываем прошлые обои.
    -- Смена обоев + палитра: rice ~/Pictures/wallpapers/<файл>
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && awww restore")

    -- История буфера обмена (Super+V)
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Агент политик доступа (окна sudo/GTK)
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Экран блокировки НЕ запускается автоматически — только Super+L

    -- Доступ root к XWayland (нужен для некоторых GTK-утилит от root)
    hl.exec_cmd("xhost +SI:localuser:root")
end)
