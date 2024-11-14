# flo's dotfiles

## Installation

```sh
    # hyprland is not packaged in the default repository
    sudo echo 'repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc' >> /etc/xbps.d/00-repository-main.conf
    # setup opendoas
    sudo echo 'permit persist :wheel' > /etc/doas.conf
    # install required packages
    sudo xbps-install -Suy $(cat ./required.xbps)
    # optional: install dev packages
    # sudo xbps-install -Suy $(cat ./dev.xbps)

    printf '\a'

    # install configurations
    chezmoi apply

    # chang shell to zsh
    chsh -s /usr/bin/zsh

    doas echo 'DEFAULT_USER=flo' >> /etc/emptty/conf

    # start required services
    doas ln -s /etc/sv/dbus /var/service
    doas ln -s /etc/sv/elogind /var/service
    doas ln -s /etc/sv/emptty /var/service
```
