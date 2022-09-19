LOG_FILE=/tmp/catalogue

echo "Setup Nodejs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

echo "Install NodeJS"
yum install nodejs -y &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

echo "Add Roboshop Application User"
useradd roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

echo "Download Catalogue Application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

cd /home/roboshop

echo "Extracting Catalogue Application code"
unzip /tmp/catalogue.zip &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS dependencies"
npm install &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi

systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE

echo "Start Catalogue Service"
systemctl start catalogue &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit
fi