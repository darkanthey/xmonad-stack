#!/bin/bash

cd ~/.xmonad/

docker build -f docker/ubuntu/Dockerfile -t xmonad-build .
docker run --rm -v  $(pwd):/home/apps/ -it xmonad-build

XMONAD_BIN=~/.local/bin
XMONAD_PATH=~/.xmonad/.stack-work/install/x86_64-linux

cd $XMONAD_PATH

TAKE_FIRST_DIRNAME=$(ls -tr|awk 'NR==0; END{print}')

ln -sf $XMONAD_PATH/$TAKE_FIRST_DIRNAME/8.2.2/bin/xmobar $XMONAD_BIN
# ln -sf $XMONAD_PATH/$TAKE_FIRST_DIRNAME/8.2.2/bin/xmonad $XMONAD_BIN
ln -sf ~/.xmonad/xmonad-x86_64-linux $XMONAD_BIN/xmonad
ln -sf $XMONAD_PATH/$TAKE_FIRST_DIRNAME/8.2.2/bin/yeganesh $XMONAD_BIN

cd ~/.xmonad/
rm -rf .local .stack

### Add PATH
[[ ":$PATH:" != *":~/.local/bin:"* ]] && PATH="~/.local/bin:${PATH}"
[[ ":$PATH:" != *":~/.xmonad/bin:"* ]] && PATH="~/.xmonad/bin:${PATH}"
