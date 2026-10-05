# CachyOS: тема/алиасы дистрибутива — на чистом Arch/Cachy файла может не быть
test -f /usr/share/cachyos-fish-config/cachyos-config.fish; and source /usr/share/cachyos-fish-config/cachyos-config.fish

# Рип-скрипты (rice, vol, powermenu, screenshot …) живут в ~/.local/bin
fish_add_path $HOME/.local/bin

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
