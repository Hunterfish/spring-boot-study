#!/bin/sh
#
#
#JAVA_HOME=/usr/java/jdk
#export JAVA_HOME=/opt/jdk1.8.0_111

APP_NAME=app-name
#java虚拟机启动参数  
JAVA_OPTS="-Xms512m -Xmx512m -Djava.awt.headless=true -XX:MaxPermSize=128m "
SPRING_BOOT_OPTS="--spring.profiles.active=uat"

usage() {
    echo "Usage: sh run.sh [start|stop]"
    exit 1
}

kills(){
    tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
    if [[ $tpid ]]; then
        echo 'Kill Process!'
        kill -9 $tpid
    fi
}

start(){
    rm -f tpid
    #nohup java -jar myapp.jar --spring.config.location=application.yml > /dev/null 2>&1 &
     java -jar $APP_NAME.jar $JAVA_OPTS $SPRING_BOOT_OPTS &
    echo $! > tpid
    echo Start Success!
}

stop(){
        tpid1=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
    echo tpid1-$tpid1
        if [[ $tpid1 ]]; then
        echo 'Stop Process...'
        kill -15 $tpid1
    fi
    sleep 5
    tpid2=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
        echo tpid2-$tpid2
    if [[ $tpid2 ]]; then
        echo 'Kill Process!'
        kill -9 $tpid2
    else
        echo 'Stop Success!'
    fi

}

check(){
    tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
    if [[ tpid ]]; then
        echo 'App is running.'
    else
        echo 'App is NOT running.'
    fi
}

case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "kill")
        kills
        ;;
    *)
        usage
        ;;
esac