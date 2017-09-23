$ jq -M 'tostring | explode | map(tonumber - 48) | add'
123
6
"123"
6
