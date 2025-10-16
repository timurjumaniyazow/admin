#!/bin/bash
# wordstats.sh
# Подсчет топ-N слов в текстовых файлах с игнорированием стоп-слов

# Проверка аргументов
if [[ $# -lt 3 ]]; then
    echo "Использование: $0 <директория> <расширение> <N> [стоп-слова-файл]"
    exit 1
fi

DIR="$1"
EXT="$2"
TOP_N="$3"
STOPWORDS_FILE="$4"

# Проверка существования директории
if [[ ! -d "$DIR" ]]; then
    echo "Ошибка: '$DIR' не является директорией"
    exit 1
fi

# Проверка стоп-слов
if [[ -n "$STOPWORDS_FILE" ]]; then
    if [[ ! -f "$STOPWORDS_FILE" ]]; then
        echo "Стоп-файл '$STOPWORDS_FILE' не найден"
        exit 1
    fi
fi

declare -A freq

# Рекурсивная обработка файлов
while IFS= read -r -d '' file; do
    # Пропустить пустые файлы
    [[ ! -s "$file" ]] && continue

    # Извлечение слов (UTF-8), нормализация
    words=$(cat "$file" | tr '[:upper:]' '[:lower:]' | grep -Po '\p{L}+')

    # Игнорируем стоп-слова
    if [[ -n "$STOPWORDS_FILE" ]]; then
        words=$(grep -v -F -x -f "$STOPWORDS_FILE" <<< "$words")
    fi

    # Подсчет частоты
    for w in $words; do
        (( freq["$w"]++ ))
    done
done < <(find "$DIR" -type f -name "*.$EXT" -print0)

# Проверка наличия слов
if [[ ${#freq[@]} -eq 0 ]]; then
    echo "Нет слов для анализа"
    exit 0
fi

# Вывод топ-N слов
for w in "${!freq[@]}"; do
    echo "$w: ${freq[$w]}"
done | sort -t ':' -k2 -nr | head -n "$TOP_N"
