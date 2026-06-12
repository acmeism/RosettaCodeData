jq -nrR 'inputs|select(length>11 and index("the"))' unixdict.txt
