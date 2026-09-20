#!/bin/bash

source .env

# Threshold limits
CPU_THRESHOLD=2
RAM_THRESHOLD=80
DISK_THRESHOLD=90

# Store values
RAM_USAGE=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')
DISK_USAGE=$(df -h / | awk '$NF=="/"{printf "%d", $5}')
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{printf "%.0f", $1}')

# Alerts
ALERT_MESSAGE=""

# Check thresholds
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    ALERT_MESSAGE+="High CPU Usage: ${CPU_USAGE}% \n"
fi

if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
    ALERT_MESSAGE+="High RAM Usage: ${RAM_USAGE}% \n"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    ALERT_MESSAGE+="High Disk Usage: ${DISK_USAGE}% \n"
fi

# Send Alert
if [ -n "$ALERT_MESSAGE" ]; then
	# creating a json payload
	PAYLOAD=$(cat <<EOF
{
"content": "🚨 **System Alert!** 🚨\n${ALERT_MESSAGE}"
}
EOF
)
	#sending POST req to the webhook
	curl -H "Content-Type: application/json" \
         -X POST \
         -d "$PAYLOAD" \
         "$WEBHOOK_URL"
         
    echo "Alert sent to Discord!"
else
    echo "System metrics are normal. No alert sent."
fi

echo "Current System Status:"
echo "RAM Usage: ${RAM_USAGE}%"
echo "Disk Usage: ${DISK_USAGE}%"
echo "CPU Usage: ${CPU_USAGE}%"
