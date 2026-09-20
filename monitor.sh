#!/bin/bash

RAM_USAGE=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')

DISK_USAGE=$(df -h / | awk '$NF=="/"{printf "%d", $5}')

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{printf "%.0f", $1}')


echo "Current System Status:"
echo "RAM Usage: ${RAM_USAGE}%"
echo "Disk Usage: ${DISK_USAGE}%"
echo "CPU Usage: ${CPU_USAGE}%"
