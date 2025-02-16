source common.sh

print_head Copy RabbitMQ repo
cp -r rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo  &>>$log_file
exit_status_print $?
print_head Install RabbitMQ
dnf install rabbitmq-server -y  &>>$log_file
exit_status_print $?

print_head Start RabbitMQ server
systemctl enable rabbitmq-server  &>>$log_file
systemctl start rabbitmq-server  &>>$log_file
exit_status_print $?

print_head Provide RAbbitMQ commands
rabbitmqctl add_user roboshop roboshop123  &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$log_file
exit_status_print $?