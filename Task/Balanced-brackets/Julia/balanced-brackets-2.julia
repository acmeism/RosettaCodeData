balancedbrackets(str::AbstractString) = foldl((x, y) -> x < 0 ? -1 : x + y, collect((x == '[') - (x == ']') for x in str), init = 0) == 0
