component=shipping
source common.sh
maven_app_setup

print_head Install mysql and SQL files 
dnf install mysql -y  &>>$log_file 
exit_status_print $?


for file in schema app-user master-data; do 
    print_head Load $file
    mysql -h mysql-dev.santoshpawar.site -uroot -pRoboShop@1 < /app/db/$file.sql  &>>$log_file
done
