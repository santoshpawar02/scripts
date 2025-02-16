source common.sh

print_head Disable/Enable Redis Repo 
dnf module disable redis -y  &>>$log_file
dnf module enable redis:7 -y  &>>$log_file
exit_status_print $?

print_head Install Redis
dnf install redis -y  &>>$log_file
exit_status_print $?

print_head Update redis config 
sed -i -e "s/127.0.0.1/0.0.0.0/" -e "/protected-mode/ c protected-mode no" /etc/redis/redis.conf  &>>$log_file
exit_status_print $?

print_head Start Redis Service
systemctl enable redis  &>>$log_file
systemctl start redis  &>>$log_file
exit_status_print $?