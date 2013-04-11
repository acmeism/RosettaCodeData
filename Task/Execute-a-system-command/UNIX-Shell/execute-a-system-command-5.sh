output=`expr \`echo hi | wc -c\` - 1`
output=$(expr $(echo hi | wc -c) - 1)
