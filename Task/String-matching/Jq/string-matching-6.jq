$ jq -n '"abcdabcd" | match("bc"; "g") | .offset'
1
5
