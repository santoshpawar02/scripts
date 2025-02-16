source common.sh

print_head Copy MongoDb repo file
cp -r mongo.repo /etc/yum.repos.d/mongo.repo  &>>$log_file
exit_status_print $?

print_head Install MongoDB
dnf install mongodb-org -y  &>>$log_file
exit_status_print $?

print_head Update MonogDB config file
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf  &>>$log_file
exit_status_print $?

print_head Start Mongod serverice
systemctl enable mongod  &>>$log_file
systemctl start mongod  &>>$log_file
systemctl restart mongod &>>$log_file
exit_status_print $?