#!/bin/bash

DATA="data/chat.txt"
LOG="logs/activity.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $*" >> "$LOG"
}

check_data() {
    if [ ! -f "$DATA" ]; then
        echo "Chat data file not found!"
        return 1
    fi
}

# Feature 1: Messages per person
feature_1() {
    echo "===== MESSAGES PER PERSON ====="
    check_data || return

    awk 'NR>1 {
        p=index($0," - ")
        rest=substr($0,p+3)
        c=index(rest,": ")
        name=substr(rest,1,c-1)
        count[name]++
    }
    END {
        for(name in count)
            print count[name],name
    }' "$DATA" | sort -nr

    log "Feature 1 completed"
}

# Feature 2: Most active hour
feature_2() {
    echo "===== MOST ACTIVE HOUR ====="
    check_data || return

    awk 'NR>1 {
        p=index($0,", ")
        hour=substr($0,p+2,2)
        count[hour]++
    }
    END {
        for(hour in count)
            print hour ":00 - " count[hour] " messages"
    }' "$DATA" | sort -nr

    log "Feature 2 completed"
}

# Feature 3: Top 10 words
feature_3() {
    echo "===== TOP 10 WORDS ====="
    check_data || return

    awk 'NR>1 {
        p=index($0,": ")
        print substr($0,p+2)
    }' "$DATA" |
    tr '[:upper:]' '[:lower:]' |
    tr -cs '[:alnum:]' '\n' |
    awk 'length($0)>2' |
    sort | uniq -c | sort -nr | head -10

    log "Feature 3 completed"
}

# Feature 4: Longest message
feature_4() {
    echo "===== LONGEST MESSAGE ====="
    check_data || return

    awk 'NR>1 {
        p=index($0,": ")
        msg=substr($0,p+2)
        if(length(msg)>max) {
            max=length(msg)
            longest=msg
        }
    }
    END {
        print "Length:",max,"characters"
        print "Message:",longest
    }' "$DATA"

    log "Feature 4 completed"
}

# Feature 5: Chat stats report
feature_5() {
    echo "===== CHAT STATS REPORT ====="
    check_data || return

    mkdir -p reports
    out="reports/report_$(date +%Y-%m-%d).txt"

    {
        echo "GROUP CHAT ANALYZER REPORT"
        echo "Generated: $(date)"
        echo
        echo "Total messages:"
        awk 'END {print NR-1}' "$DATA"
        echo
        echo "Messages per person:"
        feature_1
        echo
        echo "Most active hour:"
        feature_2
        echo
        echo "Top 10 words:"
        feature_3
        echo
        echo "Longest message:"
        feature_4
    } > "$out"

    echo "Report saved: $out"
    log "Feature 5 completed"
}

# View data
view_data() {
    check_data || return
    cat -n "$DATA"
    log "Data viewed"
}

# Backup
do_backup() {
    mkdir -p backups
    file="backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$file" data/
    echo "Backup created: $file"
    log "Backup created"
}

# View activity log
view_log() {
    echo "===== ACTIVITY LOG ====="
    tail -n 20 "$LOG"
}

# Cron task
cron_task() {
    feature_5
    echo "Cron task completed"
    log "Cron task completed"
}
