#!/bin/bash

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

function main() {
  on_start

  run_with_animation "sleep 2" "Waiting for 2 seconds"

  on_exit
}


main