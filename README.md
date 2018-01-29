# xmonad-config
xmonad-config is the [xmonad](http://xmonad.org/) configuration used by Andrew Grytsenko.

## Introduction

If you are unfamiliar with xmonad, it is a tiling window manager that is
notoriously minimal, stable, beautiful, and featureful.  If you find yourself
spending a lot of time organizing or managing windows, you may consider trying
xmonad.

This project contains a completely working and very usable xmonad
configuration "out of the box". If you are just starting out with xmonad,
this will give you a configuration that. Thought has been put into the colors, key bindings, layouts,
and supplementary scripts to make life easier.

This project is also recommended for advanced xmonad users, who may just not
want to reinvent the wheel. All source provided with this project is well
documented and simple to customize.

![Screenshot of xmonad-config](https://raw.github.com/vicfryzel/xmonad-config/master/screenshot.png)
For source code, or to contribute, see the
[xmonad-config project page](http://github.com/vicfryzel/xmonad-config).


## Requirements

* xmonad 0.13
* xmonad-contrib 0.13
* [xmobar 0.13](http://projects.haskell.org/xmobar/)
* [stalonetray 0.8.1](http://stalonetray.sourceforge.net/)
* [dmenu 4.0](http://tools.suckless.org/dmenu/)
* [yeganesh 2.5](http://dmwit.com/yeganesh/)
* [scrot 0.8](http://freshmeat.net/projects/scrot/)


# Basic Xmonad dependencies
   sudo apt install stalonetray dmenu scrot rxvt-unicode xsel feh xfce4-notifyd xfce4-power-manager xautolock i3lock


## Dockerized development environment

If you don't want to bother with the above setup you can use the provided docker environment.  Make sure you have [docker](https://www.docker.com/) 1.12+.

To spin up the environment run

``` shell
/bin/sh builder.sh
```

The working directory with xmonad will be mounted under the same path in the container so editing the files on your host machine will automatically be reflected inside the container.   To build xmonad use the steps from [Building Xmonad](#building-xmonad).


# Install Xmonad developer dependencies. If you used the docker this step you can skip.
# Installing requirements on with stack and llvm-3.9
### Install stack if you'll work with docker you can skip this step
    curl -sSL https://get.haskellstack.org/ | sh
    stack upgrade
    cd ~/.xmonad
    sudo apt install perl make automake gcc llvm-3.9
    sudo apt install libgmp-dev libffi-dev libxpm-dev libxrandr-dev libxft-dev libxml2-dev libxinerama-dev

### Building Xmonad
    cargo install ripgrep

    stack setup
    stack build
    stack install yeganesh
    bash ./build.sh


## Starting xmonad from slim, lightdm, xdm, kdm, or gdm

    ln -s ~/.xmonad/bin/xsession ~/.xsession
    # Logout, login from slim/lightdm/xdm/kdm/gdm


## Dvorak Programmer Keyboard shortcuts 

After starting xmonad, use the following keyboard shortcuts to function in
your new window manager.  I recommend you print these out so that you don't
get stranded once you logout and back in.

* Win+Shift+Enter: Start a terminal
* Win+Ctrl+l: Lock screen
* Win+p: Start dmenu.  Once it comes up, type the name of a program and enter
* Win+Shift+p: Take screenshot in select mode. Click or click and drag to select
* Win+Ctrl+Shift+p: Take fullscreen screenshot. Supports multiple monitors
* Win+Shift+a: Close focused window
* Win+Space: Change workspace layout
* Win+Shift+Space: Change back to default workspace layout
* Win+n: Refresh window
* Win+Tab: Focus next window
* Win+j: Focus next window
* Win+k: Focus previous window
* Win+m: Focus master window
* Win+Return: Swap focused window with master window
* Win+Shift+j: Swap focused window with next window
* Win+Shift+k: Swap focused window with previous window
* Win+h: Print pid of current window area
* Win+l: Expand master window area
* Win+t: Push floating window back into tiling
* Win+q: Restart xmonad. This reloads xmonad configuration, does not logout
* Win+Shift+q: Quit xmonad and logout
* Win+[1-9]: Switch to workspace 1-9, depending on which number was pressed
* Win+Shift+[1-9]: Send focused window to workspace 1-9
* Win+;: Focus left-most monitor (Xinerama screen 1)
* Win+,: Focus center-most monitor (Xinerama screen 2)
* Win+.: Focus right-most monitor (Xinerama screen 3)
* Win+Shift+;: Send focused window to workspace on left-most monitor
* Win+Shift+,: Send focused window to workspace on center-most monitor
* Win+Shift+.: Send focused window to workspace on right-most monitor
* Win+Left Mouse Drag: Drag focused window out of tiling
* Win+Right Mouse Drag: Resize focused window, bring out of tiling if needed


## Personalizing or modifying xmonad-config

All xmonad configuration is in ~/.xmonad/xmonad.hs. This includes
things like key bindings, colors, layouts, etc. You may need to have some
basic understanding of [Haskell](http://www.haskell.org/haskellwiki/Haskell)
in order to modify this file, but most people have no problems.

Most of the xmobar configuration is in ~/.xmonad/xmobar.hs.

All scripts are in ~/.xmonad/bin/. Scripts are provided to do things like
take screenshots, start the system tray, start dmenu, or fix your multi-head
layout after a fullscreen application may have turned off one of the screens.
