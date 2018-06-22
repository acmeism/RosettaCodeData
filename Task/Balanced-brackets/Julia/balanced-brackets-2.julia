balancedbrackets(str::AbstractString) = foldl((x, y) -> x < 0 ? -1 : x + y, 0, collect((x == '[') - (x == ']') for x in str)) == 0
