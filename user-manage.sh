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
    mdtool [-hv] [-add] [-del]
OPTIONS
    -h                               print help information
    -v                               print version
    -add [username] [password]       build markdown in slide format
    -del [username]                  build markdown in article format
EXAMPLES
    mdtool -add user1 123456
    mdtool -del user1
"

# --- Option processing --------------------------------------------
if [ $# == 0 ] ; then
    echo "$USAGE"
    exit 1;
fi

while getopts ":vhsa" optname
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
      "add")
        flag="add"
        ;;
      "del")
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

### Your Config ###
password=$1
username=$2
home_dir=/data/${username}
### Your Config ###

if [ "$flag" = "add" ]; then
  useradd $username -m -d $home_dir
  echo $password | passwd --stdin $username
elif [ "$flag" = "del" ]; then
  userdel -r $username
fi
