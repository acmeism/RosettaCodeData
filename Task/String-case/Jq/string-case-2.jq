"alphaBETA" | ascii_upcase
#=> "ALPHABETA"

"alphaBETA" | ascii_downcase
#=> "alphabeta"

jq -n '"á" | test("Á";"i")' # case-insensitive search
#=> true
