component=catalogue
source common.sh

dnf module disable nodejs -y
dnf module enable nodejs:20 -y

dnf install nodejs -y

useradd roboshop
cp -r catalogue.service /etc/systemd/system/catalogue.service
cp -r mongo.repo /etc/yum.repos.d/mongo.repo

rm -rf /app
mkdir /app 

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip

cd /app 
npm install 


systemd_setup

dnf install mongodb-mongosh -y

mongosh --host mongo-dev.santoshpawar.site </app/db/master-data.js