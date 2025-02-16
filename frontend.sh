source common.sh

print_head Disable default nginx
dnf module disable nginx -y &>>$log_file
exit_status_print $?

print_head Enable Nginx 24v 
dnf module enable nginx:1.24 -y &>>$log_file
exit_status_print $?

print_head Install Nginx 
dnf install nginx -y &>>$log_file
exit_status_print $?

print_head copy conf file 
cp -r nginx.conf /etc/nginx/nginx.conf &>>$log_file 
exit_status_print $?

print_head clean up old file 
rm -rf /usr/share/nginx/html/*  &>>$log_file
exit_status_print $?

print_head Download App content 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
exit_status_print $?

print_head Extract app content 
cd /usr/share/nginx/html  &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
exit_status_print $?

print_head start Nginx service 
systemctl enable nginx &>>$log_file
systemctl restart nginx  &>>$log_file
exit_status_print $?