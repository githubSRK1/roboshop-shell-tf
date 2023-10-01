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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NodeJS"

#once the user is created, if you run this script 2nd time
# this command will definiteily fail
# IMPROVEMENT : first check the user already exist or not, if not exist then create
useradd roboshop &>>$LOGFILE

# write a condition to check directory already exists or not
mkdir /app &>>$LOGFILE

cd /app &>>$LOGFILE

VALIDATE $? "Moving into app directory"

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "Downloading cart artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzipping cart"

npm install &>>$LOGFILE

VALIDATE $? "Installing dependencies"

# give full path of cart.service  because we are inside /app
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "copying cart.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable cart &>>$LOGFILE

VALIDATE $? "enabling cart"

systemctl start cart &>>$LOGFILE

VALIDATE $? "starting cart"

# cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

# VALIDATE $? "Copying mongo repo"

# yum install mongodb-org-shell -y &>>$LOGFILE

# VALIDATE $? "Installing mongo client"

# mongo --host mongodb.devopsproject.cloud < /app/schema/catalogue.js &>>$LOGFILE

# VALIDATE $? "loading catalogue data into mongodb"




