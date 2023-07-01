$ jq -n '"Hello", if 1 then error else 2 end'
"Hello"
