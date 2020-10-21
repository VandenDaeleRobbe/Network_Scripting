#!/bin/bash
touch cron
echo "0 17 * * 6 $1" >> cron
crontab cron
rm cron
