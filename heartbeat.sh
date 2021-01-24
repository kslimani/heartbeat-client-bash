#!/bin/bash
#
# A simple Heartbeat API client using curl command
#

__NAME__=$(basename "$0")
__CONFIG__="$HOME/.heartbeat"
__CURL_OPTS__="-sfL --post301 --post302 --post303"

usage()
{
  cat <<EOF
Usage: $__NAME__ <COMMAND> [options...]

Heartbeat api client.

COMMANDS :

   check        Check api configuration
   configure    Configure client
   update       Update device service status

EOF
  exit 3
}

error()
{
  echo "Error: $*" >&2
  exit 1
}

check_cmd()
{
  if ! which $1 &>/dev/null; then
    error "$1 command not found"
  fi
}

config_read()
{
  if [ -z "$HEARTBEAT_URL" -o -z "$HEARTBEAT_KEY" ]; then
    if [ ! -f $__CONFIG__ ]; then
      error "client is not configured"
    fi

    source $__CONFIG__
  fi

  if [ -z "$HEARTBEAT_CURL_MAXTIME" ]; then
    HEARTBEAT_CURL_MAXTIME=5
  fi

  if [ -z "$HEARTBEAT_URL" -o -z "$HEARTBEAT_KEY" ]; then
    error "failed to read configuration"
  fi

  config_validate $HEARTBEAT_URL $HEARTBEAT_KEY
}

config_write()
{
  config_validate $1 $2

  if ! printf "HEARTBEAT_URL=\"$1\"\nHEARTBEAT_KEY=\"$2\"\n" > $__CONFIG__; then
    error "failed to write configuration file"
  fi

  if ! chmod 600 $__CONFIG__; then
    error "failed to set configuration file permissions"
  fi

  echo "configuration writed in $__CONFIG__"
}

config_validate()
{
  if ! case $1 in https://*) ;; *) false;; esac; then
    error "configured URL is invalid"
  fi

  if [ "${#2}" -ne 39 ]; then
    error "configured KEY is invalid"
  fi
}

data_check()
{
  cat <<EOF
{"key": "$HEARTBEAT_KEY"}
EOF
}

data_status()
{
  cat <<EOF
{"key": "$HEARTBEAT_KEY", "device": "$1", "service": "$2", "status": "$3"}
EOF
}

do_configure()
{
  if [ "$#" -eq 0 ]; then
    echo "Type the api base url (ex: https://heartbeat.example.com), followed by [ENTER]:"
    read hb_url

    echo "Type the api key (XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX), followed by [ENTER]:"
    read hb_key

    config_write "$hb_url" "$hb_key"
  elif [ "$#" -eq 2 ]; then
    config_write "$@"
  else
    usage
  fi

  do_check
}

do_check()
{
  if [ "$#" -ne 0 ]; then
    usage
  fi

  check_cmd curl
  config_read

  if curl $__CURL_OPTS__ \
    --max-time $HEARTBEAT_CURL_MAXTIME \
    -X POST -H "Content-Type: application/json" \
    --data "$(data_check)" \
    "$HEARTBEAT_URL/api/status/check" &>/dev/null
  then
    echo "api check has succeeded"
  else
    error "api check has failed"
  fi
}

do_update()
{
  if [ "$#" -ne 3 ]; then
    usage
  fi

  check_cmd curl
  config_read

  if curl $__CURL_OPTS__ \
    --max-time $HEARTBEAT_CURL_MAXTIME \
    -X POST -H "Content-Type: application/json" \
    --data "$(data_status $@)" \
    "$HEARTBEAT_URL/api/status" &>/dev/null
  then
    echo "status update has succeeded"
    exit 0
  else
    error "status update has failed"
  fi
}

## MAIN
case "$1" in
  "check")
    shift
    do_check "$@"
  ;;
  "configure")
    shift
    do_configure "$@"
  ;;
  "update")
    shift
    do_update "$@"
  ;;
  *)
    usage
  ;;
esac
