using Formatting

partialsuffixes = Dict("PAIR" => "PAIRS", "SCO" => "SCORES", "DOZ" => "DOZENS",
                    "GR" => "GROSS", "GREATGR" => "GREATGROSS", "GOOGOL" => "GOOGOLS")
partials = sort(collect(keys(partialsuffixes)), lt=(a,b)->length(a)<length(b), rev=true)

multicharsuffixes = Dict("PAIRS" => 2, "SCORES" => 20, "DOZENS" => 12, "GROSS" => 144,
                         "GREATGROSS" => 1728, "GOOGOLS" => BigInt(10)^100)

twocharsuffixes = Dict(
    "KI" => BigInt(2)^10, "MI" => BigInt(2)^20, "GI" => BigInt(2)^30, "TI" => BigInt(2)^40,
    "PI" => BigInt(2)^50, "EI" => BigInt(2)^60, "ZI" => BigInt(2)^70, "YI" => BigInt(2)^80,
    "XI" => BigInt(2)^90, "WI" => BigInt(2)^100, "VI" => BigInt(2)^110, "UI" => BigInt(2)^120)
twosuff = collect(keys(twocharsuffixes))

onecharsuffixes = Dict("K" => 10^3, "M" => 10^6, "G" => 10^9, "T" => 10^12, "P" => 10^15,
                       "E" => 10^18, "Z" => 10^21, "Y" => BigInt(10)^24,
                       "X" => BigInt(10)^27, "W" => BigInt(10)^30,
                       "V" => BigInt(10)^33, "U" => BigInt(10)^36)
onesuff = collect(keys(onecharsuffixes))

function firstsuffix(s, x)
    str = uppercase(s)
    if str[1] == '!'
        lastbang = something(findfirst(x -> x != '!', str), length(str))
        return prod(x:-lastbang:1) / x, lastbang
    end
    for pstr in partials
        if match(Regex("^" * pstr), str) != nothing
            fullsuffix = partialsuffixes[pstr]
            n = length(pstr)
            while n < length(fullsuffix) && n < length(str) && fullsuffix[n+1] == str[n+1]
                n += 1
            end
            return BigInt(multicharsuffixes[fullsuffix]), n
        end
    end
    for pstr in twosuff
        if match(Regex("^" * pstr), str) != nothing
            return BigInt(twocharsuffixes[pstr]), 2
        end
    end
    for pstr in onesuff
        if match(Regex("^" * pstr), str) != nothing
            return BigInt(onecharsuffixes[pstr]), 1
        end
    end
    return 1, length(s)
end

function parsesuffix(s, x)
    str = s
    mult = BigInt(1)
    n = 1
    while n <= length(str)
        multiplier, n = firstsuffix(str, x)
        mult *= multiplier
        str = str[n+1:end]
    end
    mult
end

function suffixednumber(s)
    if (endnum = findlast(isdigit, s)) == nothing
        return NaN
    end
    x = BigFloat(replace(s[1:endnum], "," => ""))
    return x * (endnum < length(s) ? parsesuffix(s[endnum + 1:end], x) : 1)
end

const testcases =
["2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre",
 "1,567      +1.567k    0.1567e-2m",
 "25.123kK    25.123m   2.5123e-00002G",
 "25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei",
 "-.25123e-34Vikki      2e-77gooGols",
 "9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!"]

function testsuffixes()
    for line in testcases
        cases = split(line)
        println("Testing: ", string.(cases))
        println("Results: ", join(map(x -> format(suffixednumber(x), commas=true), cases), "  "), "\n")
    end
end

testsuffixes()
