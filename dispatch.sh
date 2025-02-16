component=dispatch
source common.sh

print_head Install Golang
dnf install golang -y &>>$log_file
useradd roboshop &>>$log_file
cp -r dispatch.service /etc/systemd/system/dispatch.service  &>>$log_file
exit_status_print $?

print_head Clean up /app
rm -rf /app
mkdir /app 
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip  &>>$log_file
cd /app 
exit_status_print $?

print_head Unzip artifact
unzip /tmp/dispatch.zip  &>>$log_file
cd /app 

print_head Build the App
go mod init dispatch  &>>$log_file
go get  &>>$log_file
go build &>>$log_file
exit_status_print $?

systemd_setup