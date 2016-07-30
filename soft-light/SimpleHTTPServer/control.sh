#! /bin/sh
# Description: starts databus

VERSION=0.1.2
DIRRUN=~/
DIRLOG=`pwd`/logs
CMD="python -m SimpleHTTPServer 7000"
NAME="SimpleHTTPServer"

# if [ "$1" = "-d" ]; then shift; DIRCONF=$1; shift; else DIRCONF=$DIRCONF; fi
# if [ ! -d "$DIRCONF" ]; then echo "ERROR: $DIRCONF is not a dir"; exit; fi
if [ ! -d "$DIRLOG" ]; then mkdir $DIRLOG; fi

cd "$DIRRUN"
PIDF="$DIRLOG"/"$NAME".pid
echo "Version=$VERSION \nDIRPWD=`pwd` \nDIRRUN=$DIRRUN \nNDIRCONF=$DIRCONF \nDIRLOG=$DIRLOG \nCMD=$CMD\n"

check_pid() {
    RETVAL=1
    if [ -f $PIDF ]; then
        PID=`cat $PIDF`
        # ls /proc/$PID &> /dev/null && if [ $? -eq 0 ]; then RETVAL=0; fi
		# if test $( ps -ef |grep $PID |grep -v "grep"| wc -l ) -eq 0
        count=`ps -ef |grep $PID |grep -v "grep" |wc -l`
        if [ 1 = $count ]
			then RETVAL=0
		fi
    fi
}
check_running() {
    PID=0
    RETVAL=0
    check_pid
    if [ $RETVAL -eq 0 ]; then
        echo "$NAME is running as $PID, we'll do nothing\nDIRRUN=$DIRRUN"
        exit
    fi
}
start() {
    check_running
    echo "starting $NAME ..."
	cd $DIRRUN
    $CMD 2> "$DIRLOG"/"$NAME".err > "$DIRLOG"/"$NAME".out &
    PID=$!
    echo $PID > "$PIDF"
	sleep 1
	status
}
stop() {
    check_pid
    if [ $RETVAL -eq 0 ]; then echo "$NAME is running as $PID, stopping it..."; kill $PID
    else echo "$NAME is not running, do nothing";
    fi
	while true; do
		check_pid
		if [ $RETVAL -eq 0 ]; then echo "$NAME is running, waiting it's exit..."; sleep 1;
		else echo "$NAME is stopped safely, you can restart it now"; break
		fi
	done
    if [ -f $PIDF ]; then rm $PIDF ;fi
}

status() {
    check_pid
    if [ $RETVAL -eq 0 ]; then echo "$NAME is running as $PID ...\nDIRRUN=$DIRRUN";
		else echo "$NAME is not running\n";
		# cat "$DIRLOG"/"$NAME".err
    fi
}

RETVAL=0
case "$1" in
    start)
        start $@
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start $@
        ;;
    status)
        status
        ;;
	log)
        tail -f $DIRLOG/*
        ;;
    *)
     echo "    Usage: $0 [-d EXECUTION_PATH] {start|stop|restart|status|log}"
     RETVAL=1
esac
exit $RETVAL
