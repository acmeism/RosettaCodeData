module CUSIP

function _lastdigitcusip(input::AbstractString)
    input = uppercase(input)
    s = 0

    for (i, c) in enumerate(input)
        if isdigit(c)
            v = Int(c) - 48
        elseif isalpha(c)
            v = Int(c) - 64 + 9
        elseif c == '*'
            v = 36
        elseif c == '@'
            v = 37
        elseif c == '#'
            v = 38
        end

        if iseven(i); v *= 2 end
        s += div(v, 10) + rem(v, 10)
    end

    return Char(rem(10 - rem(s, 10), 10) + 48)
end

checkdigit(input::AbstractString) = input[9] == _lastdigitcusip(input[1:8])

end  # module CUSIP

for code in ("037833100", "17275R102", "38259P508", "594918104", "68389X106", "68389X105")
    println("$code is ", CUSIP.checkdigit(code) ? "correct." : "not correct.")
end
