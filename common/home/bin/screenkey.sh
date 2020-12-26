#! /bin/bash

CMD="screenkey --opacity=1.0 --font-color=darkorange1 \
               --bg-color=#272822 -fSourceCodePro -smedium"

n=$(ps auxf | grep "screenkey --opacity" | grep -v grep)
if [ -n "$n" ]; then
    killall -9 screenkey
    [ "$1" == "restart" ] && $CMD
else
    [ "$1" == "stop" ] || $CMD
fi
