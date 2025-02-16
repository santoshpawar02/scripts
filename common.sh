systemd_setup () {
    print_head Copy SystemD Service Files
    cp -r $pwd/$component.service /etc/systemd/system/$component.service &>>$log_file 
    exit_status_print $?
    print_head Start Service 
    systemctl daemon-reload &>>$log_file 
    systemctl enable $component &>>$log_file
    systemctl restart $component &>>$log_file
    exit_status_print $?
}


artifact_download () {
    print_head User Add roboshop
    id roboshop &>>$log_file
    if [ $? -ne 0]; then
        useradd roboshop &>>$log_file
    fi
    exit_status_print $?
    print_head remove app folder
    rm -rf /app &>>$log_file
    exit_status_print $?
    mkdir /app  &>>$log_file
    curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component-v3.zip
    exit_status_print $?
    cd /app  &>>$log_file
    unzip /tmp/$component.zip  &>>$log_file
    exit_status_print $?
}

nodejs_app_setup () {
    print_head Enable/Disable nodejs repo
    dnf module disable nodejs -y  &>>$log_file
    dnf module enable nodejs:20 -y  &>>$log_file
    dnf install nodejs -y  &>>$log_file
    exit_status_print $?
    artifact_download
    cd /app  &>>$log_file
    print_head Install nodejs dependencis
    npm install  &>>$log_file
    exit_status_print $?
    systemd_setup    
}

maven_app_setup() {
    print_head Install Maven
    dnf install maven -y  &>>$log_file
    exit_status_print $?
    artifact_download
    cd /app 
    print_head Install Maven dependencies
    mvn clean package  &>>$log_file
    mv target/$component-1.0.jar $component.jar  &>>$log_file 
    exit_status_print $?
    systemd_setup
}

python_app_setup() {
    print_head Install Python Packages
    dnf install python3 gcc python3-devel -y  &>>$log_file
    exit_status_print $?
    artifact_download 
    cd /app 
    print_head Install Python Dependencies
    pip3 install -r requirements.txt  &>>$log_file
    exit_status_print $?
    systemd_setup
}

print_head() {
    echo -e "\e[35m$*\e[0m" 
    echo "#################################################################" &>>$log_file
    echo -e "\e[36m$*\e[0m"
    echo "#################################################################"  &>>$log_file
}

log_file=/tmp/roboshop.log
rm -f /$log_file

exit_status_print() {
   if [$1 -eq 0]; then
    echo -e "\e[32m >> SUCCESS\e[om" 
   else
    echo -e "\e[31m >> FAILURE\e[0m"
    lno=$(cat -n /tmp/roboshop.log | grep '#################################################################' | tail -n 2 | head -n 1 | awk '{print $1}')
    echo
    echo
    sed -n -e "$lno,$ p" /tmp/roboshop.log
    echo
    exit 1
   fi   
}

pwd=$(pwd)