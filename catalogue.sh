component=catalogue
source common.sh

print_head Copy repo file for Mongo
cp -r mongo.repo /etc/yum.repos.d/mongo.repo  &>>$log_file
exit_status_print $?

nodejs_app_setup 

print_head Install MongoDB
dnf install mongodb-mongosh -y &>>$log_file
exit_status_print $?

print_head Load MongoDB master data
mongosh --host mongo-dev.santoshpawar.site </app/db/master-data.js &>>$log_file
exit_status_print $?