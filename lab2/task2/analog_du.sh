#!/bin/bash
# Аналог du: подсчёт размера директорий без использования du и ls
# Использование: ./my_du.sh /путь/к/папке

# Проверяем, указан ли аргумент
if [ -z "$1" ]; then
    echo "Использование: $0 <путь_к_папке>"
    exit 1
fi

# Проверяем, существует ли путь
if [ ! -d "$1" ]; then
    echo "Ошибка: '$1' не является папкой."
    exit 1
fi

# Функция для преобразования байтов в человеко-читаемый формат
human_readable() {
    local bytes=$1
    if (( bytes < 1024 )); then
        echo "${bytes}B"
    elif (( bytes < 1048576 )); then
        echo "$((bytes / 1024))K"
    elif (( bytes < 1073741824 )); then
        printf "%.1fM\n" "$(echo "$bytes / 1048576" | bc -l)"
    else
        printf "%.1fG\n" "$(echo "$bytes / 1073741824" | bc -l)"
    fi
}

# Функция для подсчёта размера директории рекурсивно
calculate_size() {
    local dir="$1"
    local total=0
    while IFS= read -r -d '' file; do
        size=$(stat -c %s "$file" 2>/dev/null)
        (( total += size ))
    done < <(find "$dir" -type f -print0 2>/dev/null)
    echo "$total"
}

# Основной цикл по поддиректориям
find "$1" -type d | while read -r subdir; do
    total_bytes=$(calculate_size "$subdir")
    total_hr=$(human_readable "$total_bytes")
    echo "$subdir: $total_hr"
done
