#!/bin/bash

stack build
stack install yeganesh

stack --verbose --stack-yaml stack.yaml ghc -- --make xmonad.hs -i -ilib -fllvm -threaded -fforce-recomp -main-is main -v0 -o xmonad-x86_64-linux
