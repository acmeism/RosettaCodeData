$ jq -n '"Hello" | if 1 then error else 2 end'
jq: error: Hello
