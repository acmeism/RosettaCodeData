using Printf

const suf = Dict{BigInt, String}(BigInt(1) => "", BigInt(10)^100 => "googol",
    BigInt(10)^3 => "K", BigInt(10)^6 => "M", BigInt(10)^9 => "G", BigInt(10)^12 => "T",
    BigInt(10)^15 => "P", BigInt(10)^18 => "E", BigInt(10)^21 => "Z", BigInt(10)^24 => "Y",
    BigInt(10)^27 => "X", BigInt(10)^30 => "W", BigInt(10)^33 => "V", BigInt(10)^36 => "U")
const binsuf = Dict{BigInt, String}(BigInt(1) => "", BigInt(10)^100 => "googol",
    BigInt(2)^10 => "Ki", BigInt(2)^20 => "Mi", BigInt(2)^30 => "Gi", BigInt(2)^40 => "Ti",
    BigInt(2)^50 => "Pi", BigInt(2)^60 => "Ei", BigInt(2)^70 => "Zi", BigInt(2)^80 => "Yi",
    BigInt(2)^90 => "Xi", BigInt(2)^100 => "Wi", BigInt(2)^110 => "Vi", BigInt(2)^120 => "Ui")
const googol = BigInt(10)^100

function choosedivisor(n, base10=true)
    if n > 10 * googol
        return googol
    end
    s = base10 ? sort(collect(keys(suf))) : sort(collect(keys(binsuf)))
    (i = findfirst(x -> x > 0.001 * n, s)) == nothing ? s[end] : s[i]
end

pretty(x) = (floor(x) == x) ? string(BigInt(x)) : replace(@sprintf("%f", x), r"0+$" => "")

function suffize(val::String, rounddigits=-1, suffixbase=10)
    if val[1] == '-'
        isneg = true
        val = val[2:end]
    else
        isneg = false
        if val[1] == '+'
            val = val[2:end]
        end
    end
    val = replace(val, r"," => "")
    nval = (b = tryparse(BigInt, val)) == nothing ? parse(BigFloat, val) : b
    b = choosedivisor(nval, suffixbase != 2)
    mantissa = nval / b
    if rounddigits >= 0
        mantissa = round(mantissa, digits=rounddigits)
    end
    (isneg ? "-" : "") * pretty(mantissa) * (suffixbase == 10 ? suf[b] : binsuf[b])
end
suffize(val::Number, rounddigits=-1, suffixbase=10) = suffize(string(val), rounddigits, suffixbase)

testnumbers = [
   ["87,654,321"],
   ["-998,877,665,544,332,211,000", 3],
   ["+112,233", 0],
   ["16,777,216", 1],
   ["456,789,100,000,000"],
   ["456,789,100,000,000", 2, 10],
   ["456,789,100,000,000", 5, 2],
   ["456,789,100,000.000e+00", 0],
   ["+16777216", 0, 2],
   ["1.2e101"]]

for l in testnumbers
    n = length(l)
    s = (n == 1) ? suffize(l[1]) : (n == 2) ? suffize(l[1], l[2]) : suffize(l[1], l[2], l[3])
    println(lpad(l[1], 30), (n > 1) ? lpad(l[2], 3) : "   ",
                            (n > 2) ? lpad(l[3], 3) : "   ", " : ", s)
end
