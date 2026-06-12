const nibs = [0b0, 0b1, 0b10, 0b11, 0b100, 0b101, 0b110, 0b111, 0b1000, 0b1001]

"""
    function bcd_decode(data::Vector{codeunit}, sgn, decimalplaces; table = nibs)

Decode BCD number
    bcd: packed BCD data as vector of bytes
    sgn: sign(positive 1, negative -1, zero 0)
    decimalplaces: decimal places from end for placing decimal point (-1 if none)
    table: translation table, defaults to same as nibble (nibs table)
"""
function bcd_decode(bcd::Vector{UInt8}, sgn, decimalplaces = 0; table = nibs)
    decoded = 0
    for (i, byt) in enumerate(bcd)
        decoded = decoded * 10 + table[byt >> 4 + 1]
        decoded = decoded * 10 + table[byt & 0b1111 + 1]
    end
    return decimalplaces == 0 ? sgn * decoded : sgn * decoded / 10^decimalplaces
end

"""
    function bcd_encode(number::Real; table::Vector{UInt8} = nibs)

Encode real number as BCD.
    `number`` is in native binary formats
    `table`` is the table used for encoding the nibbles of the decimal digits, default `nibs`
    Returns: BCD encoding vector of UInt8, number's sign (1, 0 -1), and position of decimal point
"""
function bcd_encode(number::Real; table::Vector{UInt8} = nibs)
    if (sgn = sign(number)) < 0
        number = -number
    end
    s = string(number)
    if (exponentfound = findlast(ch -> ch in ['e', 'E'], s)) != nothing
        expplace = parse(Int, s[exponentfound+1:end])
        s = s[begin:exponentfound-1]
    else
        expplace = 0
    end
    if (decimalplaces = findfirst(==('.'), s)) != nothing
        s = s[begin:decimalplaces-1] * s[decimalplaces+1:end]
        decimalplaces = length(s) - decimalplaces + 1
        decimalplaces -= expplace
    else
        decimalplaces = -expplace
    end
    len = length(s)
    if isodd(len)
        s = "0" * s
        len += 1
    end
    return [table[s[i+1]-'0'+1] | (table[s[i]-'0'+1] << 4) for i in 1:2:len-1], sgn, decimalplaces
end

"""
    function bcd_encode(number::Integer; table::Vector{UInt8} = nibs)

Encode integer as BCD.
    `number`` is in native binary formats
    `table`` is the table used for encoding the nibbles of the decimal digits, default `nibs`
    Returns: Tuple containg two values: a BCD encoded vector of UInt8 and the number's sign (1, 0 -1)
"""
function bcd_encode(number::Integer; table::Vector{UInt8} = nibs)
    if (sgn = sign(number)) < 0
        number = -number
    end
    s = string(number)
    len = length(s)
    if isodd(len)
        s = "0" * s
        len += 1
    end
    return [table[s[i+1]-'0'+1] | (table[s[i]-'0'+1] << 4) for i in 1:2:len-1], sgn
end


for test in [1, 2, 3, -9876, 10, 12342436]
    enc = bcd_encode(test, table = nibs)
    dec = bcd_decode(enc..., table = nibs)
    println("$test encoded is $enc, decoded is $dec")
end

for test in [-987654.321, -10.0, 9.9999, 123424367.0089]
    enc = bcd_encode(test, table = nibs)
    dec = bcd_decode(enc..., table = nibs)
    println("$test encoded is $enc, decoded is $dec")
end

println("BCD 19 ($(bcd_encode(19)[1])) + BCD 1 ($(bcd_encode(1))[1]) = BCD 20 " *
   "($(bcd_encode(bcd_decode(bcd_encode(19)...) + bcd_decode(bcd_encode(1)...))))")
println("BCD 30 ($(bcd_encode(30)[1])) - BCD 1 ($(bcd_encode(1))[1]) = BCD 29 " *
   "($(bcd_encode(bcd_decode(bcd_encode(30)...) - bcd_decode(bcd_encode(1)...))))")
println("BCD 99 ($(bcd_encode(99)[1])) + BCD 1 ($(bcd_encode(1))[1]) = BCD 100 " *
   "($(bcd_encode(bcd_decode(bcd_encode(99)...) + bcd_decode(bcd_encode(1)...))))")
