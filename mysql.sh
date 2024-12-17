#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
     then 
       echo -e "$2... $R FAILURE $N"
       exit 1
    else 
      echo -e "$2...$G SUCCESS $N"
    fi
     
}


if [ $USERID -ne 0 ]
  then 
    echo "please run this script with root access."
    exit 1
else 

    echo "you are super user."
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "Setting the root password"

#Below code wull be useful for idempotatent nature

mysql -h db.aws-9s.shop -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0]
 then 
   mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "MySQL Root password Setup"

  else 
    echo -e "MySQL Root password is already setup...$R SKIPPING $N"
fi 