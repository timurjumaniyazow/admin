#!/bin/bash
# backup.sh
# Резервное копирование директории с ротацией архивов старше 7 дней
# Использование: ./backup.sh <директория_для_бэкапа> <директория_для_архивов>

# Проверка аргументов
if [[ -z "$1" || -z "$2" ]]; then
    echo "Использование: $0 <директория_для_бэкапа> <директория_для_архивов>"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"

# Проверка существования директорий
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Ошибка: директория для бэкапа '$SOURCE_DIR' не существует"
    exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Директория для архивов не существует, создаю..."
    mkdir -p "$BACKUP_DIR"
fi

# Имя архива с текущей датой
DATE=$(date +%Y-%m-%d)
BASENAME=$(basename "$SOURCE_DIR")
ARCHIVE_NAME="${BASENAME}_${DATE}.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# Создание архива
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$BASENAME"

# Проверка успешности создания
if [[ $? -eq 0 && -f "$ARCHIVE_PATH" ]]; then
    echo "Резервная копия создана успешно: $ARCHIVE_PATH"
else
    echo "Ошибка при создании архива"
    exit 1
fi

# Удаление архивов старше 7 дней
find "$BACKUP_DIR" -name "${BASENAME}_*.tar.gz" -type f -mtime +7 -exec rm -v {} \;

echo "Ротация архивов выполнена."
