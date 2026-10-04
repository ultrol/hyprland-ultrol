-- Внешний вид: мягкие цвета палитры, скругления, прозрачность и размытие.
-- Цвета приходят из config/colors.lua (генерируется скриптом rice).
-- Прозрачность: https://gist.github.com/lopspower/03f0a94a337a04a8b76c9e54c961d310

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 14,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { COL_ACCENT_RGBA, COL_ACCENT2_RGBA },
                angle = 45,
            },
            inactive_border = COL_BORDER_IDLE_RGBA,
        },
    },

    group = {
        col = {
            border_active = COL_ACCENT_RGBA,
            border_inactive = COL_BORDER_IDLE_RGBA,
            border_locked_active = COL_CRITICAL_RGBA,
            border_locked_inactive = COL_BORDER_IDLE_RGBA,
        },
        groupbar = {
            col = {
                active = COL_ACCENT_RGBA,
                inactive = COL_BORDER_IDLE_RGBA,
                locked_active = COL_CRITICAL_RGBA,
                locked_inactive = COL_BORDER_IDLE_RGBA,
            },
        },
    },

    decoration = {
        dim_special = 0.3,
        rounding = 12,
        active_opacity = 0.97,
        inactive_opacity = 0.90,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            special = true,
            vibrancy = 0.12,
        },
        shadow = {
            enabled = true,
            range = 24,
            render_power = 3,
            color = "rgba(00000055)",
        },
    },
})
