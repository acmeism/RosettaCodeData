< 135-0.txt jq -nR --argjson n 10 '
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

bow(inputs | gsub("[^-a-zA-Z]"; " ") | splits("  *") | ascii_downcase | select(test("^[a-z][-a-z]*$")))
| to_entries
| sort_by(.value)
| .[- $n :]
| reverse
| from_entries
'
