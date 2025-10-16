#!/bin/bash
# sort_by_extension.sh
# Скрипт сортирует файлы по расширениям в отдельные подпапки
# Использование:
#   ./sort_by_extension.sh /путь/к/папке

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Использование: $0 <путь_к_папке>"
    exit 1
fi

TARGET_DIR="$1"

# Проверяем, существует ли директория
if [ ! -d "$TARGET_DIR" ]; then
    echo "Ошибка: '$TARGET_DIR' не является папкой."
    exit 1
fi

# Проходим по всем файлам в директории (только текущий уровень)
find "$TARGET_DIR" -maxdepth 1 -type f | while read -r file; do
    filename=$(basename "$file")
    # Получаем расширение (последнее после точки)
    ext="${filename##*.}"
    
    # Если нет точки или расширение совпадает с именем файла → no_extension
    if [[ "$filename" == "$ext" ]]; then
        ext="no_extension"
    fi

    # Создаём папку для расширения, если не существует
    mkdir -p "$TARGET_DIR/$ext"

    # Перемещаем файл
    mv "$file" "$TARGET_DIR/$ext/"
done

echo "Сортировка завершена."
