#!/bin/bash
# ==============================================
# Программа: system_info.sh
# Назначение: Сбор системной информации
# ==============================================

separator="========================================"

# ---------- Функции ----------
show_section() {
    echo "$separator"
    echo "$1"
    echo "$separator"
    eval "$2"
    echo
}

collect_all_info() {
    echo "$separator"
    echo "ПОЛНЫЙ СИСТЕМНЫЙ ОТЧЁТ"
    echo "$separator"

    show_section "1. Текущий рабочий каталог" "pwd"
    show_section "2. Текущий запущенный процесс" "ps -p $$"
    show_section "3. Домашний каталог" "echo \$HOME"
    show_section "4. Название и версия ОС" "cat /etc/os-release"
    show_section "5. Доступные оболочки" "cat /etc/shells"
    show_section "6. Текущие пользователи" "who"
    show_section "7. Количество пользователей" "who | wc -l"
    show_section "8. Информация о жестких дисках" "lsblk"
    show_section "9. Информация о процессоре" "lscpu"
    show_section "10. Информация о памяти" "free -h"
    show_section "11. Информация о файловой системе" "df -h"

    if command -v dpkg >/dev/null 2>&1; then
        show_section "12. Установленные пакеты (dpkg, первые 30)" "dpkg -l | head -n 30"
    elif command -v rpm >/dev/null 2>&1; then
        show_section "12. Установленные пакеты (rpm, первые 30)" "rpm -qa | head -n 30"
    else
        show_section "12. Установленные пакеты" "echo 'Неизвестный менеджер пакетов'"
    fi
}

# ---------- Проверка аргумента командной строки ----------
if [[ "$1" == "--tofile" && -n "$2" ]]; then
    outfile="$2"
    collect_all_info > "$outfile" 2>/dev/null
    echo "Отчёт сохранён в файл: $outfile"
    exit 0
fi

# ---------- Главное меню ----------
while true; do
    clear
    echo "$separator"
    echo "     СИСТЕМНАЯ ИНФОРМАЦИЯ"
    echo "$separator"
    echo "1. Текущий рабочий каталог"
    echo "2. Текущий запущенный процесс"
    echo "3. Домашний каталог"
    echo "4. Название и версия ОС"
    echo "5. Доступные оболочки"
    echo "6. Текущие пользователи"
    echo "7. Количество пользователей"
    echo "8. Информация о жестких дисках"
    echo "9. Информация о процессоре"
    echo "10. Информация о памяти"
    echo "11. Информация о файловой системе"
    echo "12. Информация об установленных пакетах ПО"
    echo "13. Сохранить ВСЮ информацию в output.txt"
    echo "0. Выход"
    echo "$separator"
    read -p "Выберите пункт меню: " choice

    case $choice in
        1) show_section "Текущий рабочий каталог" "pwd" ;;
        2) show_section "Текущий запущенный процесс" "ps -p $$" ;;
        3) show_section "Домашний каталог" "echo \$HOME" ;;
        4) show_section "Название и версия ОС" "cat /etc/os-release" ;;
        5) show_section "Доступные оболочки" "cat /etc/shells" ;;
        6) show_section "Текущие пользователи" "who" ;;
        7) show_section "Количество пользователей" "who | wc -l" ;;
        8) show_section "Информация о жестких дисках" "lsblk" ;;
        9) show_section "Информация о процессоре" "lscpu" ;;
        10) show_section "Информация о памяти" "free -h" ;;
        11) show_section "Информация о файловой системе" "df -h" ;;
        12)
            if command -v dpkg >/dev/null 2>&1; then
                show_section "Информация об установленных пакетах ПО" "dpkg -l | head -n 30"
            elif command -v rpm >/dev/null 2>&1; then
                show_section "Информация об установленных пакетах ПО" "rpm -qa | head -n 30"
            else
                show_section "Информация об установленных пакетах ПО" "echo 'Неизвестный менеджер пакетов'"
            fi
            ;;
        13)
            collect_all_info > output.txt 2>/dev/null
            echo "Отчёт сохранён в файл output.txt"
            ;;
        0)
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверный выбор!"
            ;;
    esac

    echo
    read -p "Нажмите Enter, чтобы продолжить..."
done
