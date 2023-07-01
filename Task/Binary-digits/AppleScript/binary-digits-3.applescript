on intToBinary(n)
    set binary to (n mod 2 div 1) as text
    set n to n div 2
    repeat while (n > 0)
        set binary to ((n mod 2 div 1) as text) & binary
        set n to n div 2
    end repeat

    return binary
end intToBinary

display dialog ¬
    intToBinary(5) & linefeed & ¬
    intToBinary(50) & linefeed & ¬
    intToBinary(9000) & linefeed
