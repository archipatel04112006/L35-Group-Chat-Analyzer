#!/bin/bash

cd "$(dirname "$0")" || exit 1

source lib/functions.sh

if [ "$1" = "--cron" ]; then
    cron_task
    exit 0
fi

while true
do
    echo
    echo "====== GROUP CHAT ANALYZER ======"
    echo "1. Messages per person"
    echo "2. Most active hour"
    echo "3. Top 10 words"
    echo "4. Longest message"
    echo "5. Chat stats report"
    echo "6. View data"
    echo "7. Backup data"
    echo "8. View activity log"
    echo "0. Exit"

    read -p "Enter your choice: " ch

    case $ch in
        1) feature_1 ;;
        2) feature_2 ;;
        3) feature_3 ;;
        4) feature_4 ;;
        5) feature_5 ;;
        6) view_data ;;
        7) do_backup ;;
        8) view_log ;;
        0) echo "Thank you!"; break ;;
        *) echo "Invalid choice!" ;;
    esac
done
