#!/bin/bash

helper () {
    cat << EOF
$0 <OPTIONS>

OPTIONS:
    -w or --wordlist        dictionnary.
    -l or --log-file        log file to work on.
    -h or --help            this help menu.
EOF
}

while [ "$1" != "" ]; do
    if [ "$1" == "-h" -o "$1" == "-help" ]; then
        helper
    fi
    if [ "$1" == "-w" -o "$1" == "--wordlist" ]; then
        DICT=${2:/usr/share/dict/words}
    fi
    if [ "$1" == "-l" -o "$1" == "--log-file" ]; then
        LOG_FILE=${2:/usr/local/var/log/radius}
    fi
    shift 2
done

JOHN=/usr/sbin/john
CHALLENGE=$(cat $LOG_FILE | grep challenge | awk '{print $2;}')
RESPONSE=$(cat $LOG_FILE | grep response | awk '{print $2;}')

john --stdout --wordlist=$DICT | asleap -C $CHALLENGE -R $RESPONSE -W -
