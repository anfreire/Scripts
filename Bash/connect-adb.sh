#!/bin/bash

PORT="5555"

function animate {
  while true; do
    echo -ne "\r[     ] $1"
    sleep 0.2
    echo -ne "\r[ .   ] $1"
    sleep 0.2
    echo -ne "\r[ ..  ] $1"
    sleep 0.2
    echo -ne "\r[ ... ] $1"
    sleep 0.2
    echo -ne "\r[  .. ] $1"
    sleep 0.2
    echo -ne "\r[   . ] $1"
    sleep 0.2
  done
}

function run_with_animation {
  COMMAND=$1
  shift
  MESSAGE=$*
  animate "$MESSAGE" &
  ANIMATE_PID=$!
  $COMMAND > /dev/null 2>&1
  STATUS=$?
  kill $ANIMATE_PID
  if [ $STATUS -eq 0 ]; then
    echo -e "\r[  \033[0;32mOK\033[0m  ] $MESSAGE"
  else
    echo -e " \r[ \033[0;31mFAIL\033[0m ] $MESSAGE"
  fi
}

function on_start() {
  tput civis
  trap on_exit SIGINT SIGTERM EXIT ERR
}

function on_exit() {
  tput cnorm
  exit 0
}

function connect_scrcpy() {
    echo -n "Do you want to start scrcpy? [y/n] "
    read
    if [ "$REPLY" == "y" ]; then
        nohup scrcpy > /dev/null 2>&1 &
        rm -f nohup.out
    fi
}

function wait_usb_disconnect() {
    while true ; do
        STILL_CONNECTED=$(eval "adb devices | grep -v List | grep device")
        if [ -z "$STILL_CONNECTED" ]; then
            break
        fi
        sleep 1
    done
}

function main() {
  on_start

  adb disconnect > /dev/null 2>&1
  adb kill-server > /dev/null 2>&1
  adb start-server > /dev/null 2>&1
  adb tcpip $PORT > /dev/null 2>&1
  run_with_animation "adb wait-for-device" "Waiting for USB connect"
  IP=$(eval "adb shell ifconfig wlan0 | grep \"inet addr\" | cut -d: -f2 | cut -d\" \" -f1")
  run_with_animation wait_usb_disconnect "Waiting for USB disconnect"
  adb connect "$IP":$PORT > /dev/null 2>&1
  connect_scrcpy

  on_exit
}


main