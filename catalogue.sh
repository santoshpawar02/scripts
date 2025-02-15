component=catalogue
source common.sh

cp -r mongo.repo /etc/yum.repos.d/mongo.repo

nodejs_app_setup

dnf install mongodb-mongosh -y

mongosh --host mongo-dev.santoshpawar.site </app/db/master-data.js