source common.sh

print_head Install MySQL
dnf install mysql-server -y  &>>$log_file
exit_status_print $?

print_head Start MysqlD service 
systemctl enable mysqld  &>>$log_file
systemctl start mysqld   &>>$log_file
mysql_secure_installation --set-root-pass RoboShop@1  &>>$log_file
exit_status_print $?