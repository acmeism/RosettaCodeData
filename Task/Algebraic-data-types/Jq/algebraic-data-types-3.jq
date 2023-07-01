jq -n -f pattern-matching.jq | grep -v '[][]' | tr -d ',"'
