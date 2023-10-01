#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

yum install golang -y &>>$LOGFILE

VALIDATE $? "Installation of golang"

useradd roboshop &>>$LOGFILE

VALIDATE $? "adding roboshop user"

mkdir /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

cd /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>$LOGFILE

VALIDATE $? "downloading application code"

cd /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

unzip /tmp/dispatch.zip &>>$LOGFILE

VALIDATE $? "unzipping"

cd /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

go mod init dispatch &>>$LOGFILE

VALIDATE $? "download dependencies"

go get &>>$LOGFILE

VALIDATE $? "download dependencies"

go build &>>$LOGFILE

VALIDATE $? "build the siftware"

cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>$LOGFILE

VALIDATE $? "copy dispatch service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Load the service"

systemctl enable dispatch &>>$LOGFILE

VALIDATE $? "enable dispatch"

systemctl start dispatch &>>$LOGFILE

VALIDATE $? "start dispatch"