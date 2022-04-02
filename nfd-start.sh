#!/bin/sh

VERSION=`nfd --version`

case "$1" in
  -h)
    echo Usage
    echo $0
    echo "  Start NFD"
    exit 0
    ;;
  -V)
    echo $VERSION
    exit 0
    ;;
  "") ;; # do nothing
  *)
    echo "Unrecognized option $1"
    exit 1
    ;;
esac

hasProcess() {
  local processName=$1

  if pgrep -x $processName >/dev/null
  then
    echo $processName
  fi
}

hasNFD=$(hasProcess nfd)

if [ -n "$hasNFD" ]
then
  echo 'NFD is already running...'
  exit 1
fi

if ! ndnsec-get-default &>/dev/null
then
  ndnsec-keygen /localhost/operator | ndnsec-install-cert -
fi
sh -c ./init.sh &
exec /usr/local/bin/nfd