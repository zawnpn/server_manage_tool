#!/bin/bash
# ------------------------------------------------------------------
# [Author] Wanpeng Zhang 
#          Server Manage Tool
#          https://github.com/zawnpn/server_manage_tool
# ------------------------------------------------------------------

SUBJECT=user-manage
VERSION=0.1.0
USAGE="
USAGE
    ./user-manage.sh [-hv] [-ad] username
OPTIONS
    -h                               print help information
    -v                               print version
    -a [username]                    add user & user_dir
    -d [username]                    del user & user_dir
EXAMPLES
    ./user-manage.sh -a user1
    ./user-manage.sh -d user1
"

# --- Option processing --------------------------------------------
if [ $# == 0 ] ; then
    echo "$USAGE"
    exit 1;
fi

while getopts ":vhad" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "h")
        echo "$USAGE"
        exit 0;
        ;;
      "a")
        flag="add"
        ;;
      "d")
        flag="del"
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

# -----------------------------------------------------------------

LOCK_FILE=/tmp/${SUBJECT}.lock

if [ -f "$LOCK_FILE" ]; then
	echo "Script is already running"
	exit
fi

# -----------------------------------------------------------------
trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE 

# -----------------------------------------------------------------
#  SCRIPT LOGIC
# -----------------------------------------------------------------
#! /bin/bash

# Your Config
username=$1
user_dir=/data/${username}
user_shell=/bin/bash
docs="\n
账号: $username\n
密码: \n
校内使用: ssh $username@x.x.x.x\n
校外临时: ssh $username@x.x.x.x -p xxxx\n"

if [ "$flag" = "add" ]; then
  sudo useradd $username -m -d $user_dir -s $user_shell
  sudo passwd $username
  echo -e $docs
elif [ "$flag" = "del" ]; then
  sudo userdel -r $username
fi

