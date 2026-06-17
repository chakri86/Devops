
#!/bin/bash

app_name=shipping
MYSQL_HOST=mysql.avkc.online
source ./common.sh

check_root 


app_setup

java_setup

systemd_setup

dnf install mysql -y &>> $log_file
validate $? "Installing MySQL client"

mysql -h $MYSQL_HOST -u root -pRoboShop@1 -e "use cities" &>>$LOGS_FILE
if [ $? -ne 0 ]; then
  mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
  mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql
  mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
  validate $? "$time_stamnp [INFO] ${G} Data loaded successfully.${N}" | tee -a $log_file
else
  echo -e "$time_stamnp [INFO] ${Y} Data already loaded ... SKIPPING $N" | tee -a $log_file
fi

app_restart

print_total_time


