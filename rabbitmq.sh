COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
StatusCheck $?

echo "Install Erlang dependency that is needed for RabbitMQ"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm  -y &>>$LOG_FILE
StatusCheck $?

echo "Install RabbitMQ"
yum install --nobest rabbitmq-server -y &>>$LOG_FILE
StatusCheck $?

echo "Start RabbitMQ server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
StatusCheck $?

sudo rabbitmqctl list_users | grep roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
  echo "Add apllication user in RabbitMQ"
  rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
  StatusCheck $?
fi

echo "Add Application user tags in RabbitMQ"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
StatusCheck $?

echo "Add permissions for App user in RabbitMQ"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
StatusCheck $?
