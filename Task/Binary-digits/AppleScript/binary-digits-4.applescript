on intToBinary(n)
    set binary to ""
    repeat
        -- Calculate an integer value whose 8 decimal digits are the same as the low 8 binary digits of n's current value.
        set binAsDec to (n div 128 mod 2 * 10000000 + n div 64 mod 2 * 1000000 + n div 32 mod 2 * 100000 + ¬
            n div 16 mod 2 * 10000 + n div 8 mod 2 * 1000 + n div 4 mod 2 * 100 + n div 2 mod 2 * 10 + n mod 2) div 1
        -- Coerce to text as appropriate, prepend to the output text, and prepare to get another 8 digits or not as necessary.
        if (n > 255) then
            set binary to text 2 thru -1 of ((100000000 + binAsDec) as text) & binary
            set n to n div 256
        else
            set binary to (binAsDec as text) & binary
            exit repeat
        end if
    end repeat

    return binary
end intToBinary

display dialog ¬
    intToBinary(5) & linefeed & ¬
    intToBinary(50) & linefeed & ¬
    intToBinary(9000) & linefeed
