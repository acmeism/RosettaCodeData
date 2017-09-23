for file
do
  jq -Rr 'gsub($from; $to)' --arg from 'Goodbye London!' --arg to 'Hello New York!' "$file" |
    sponge "$file"
done
