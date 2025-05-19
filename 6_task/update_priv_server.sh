#!/bin/bash

PRIVATE_KEY="$HOME/RSA-key.pem"
PRIVATE_USER="ec2-user"
PRIVATE_HOST="10.0.2.145"
LOG_FILE="update_log_$(date +%F_%T).txt"

if [ ! -f "$PRIVATE_KEY" ]; then
  echo "Приватный ключ не найден: $PRIVATE_KEY"
  exit 1
fi

echo "Проверка ключа прошла успешно."


echo "Подключаемся к $PRIVATE_USER@$PRIVATE_HOST..."

ssh -i "$PRIVATE_KEY" "$PRIVATE_USER@$PRIVATE_HOST" 'echo "Успешно подключились к приватному серверу."; 
echo "Начинаем обновление пакетов...";
sudo yum update -y;
echo "Обновление завершено."' | tee "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "Скрипт успешно отработал. Лог: $LOG_FILE"
else
    echo "Произошла ошибка во время выполнения. Лог: $LOG_FILE"
fi
