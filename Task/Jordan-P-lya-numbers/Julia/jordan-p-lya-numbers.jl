function aupto(limit::T) where T <: Integer
    res = map(factorial, T(1):T(18))
    k = 2
    while k < length(res)
        rk = res[k]
        for j = 2:length(res)
            kl = res[j] * rk
            kl > limit && break
            while kl <= limit && kl ∉ res
                push!(res, kl)
                kl *= rk
             end
        end
        k += 1
    end
    return sort!((sizeof(T) > sizeof(Int) ? T : Int).(res))[begin+1:end]
end

const factorials = map(factorial, 2:18)

""" Factor a J-P number into a smallest vector of factorials and their powers """
function factor_as_factorials(n::T) where T <: Integer
    fac_exp = Tuple{Int, Int}[]
    for idx in length(factorials):-1:1
        m = n
        empty!(fac_exp)
        for i in idx:-1:1
            expo = 0
            while m % factorials[i] == 0
                expo += 1
                m ÷= factorials[i]
            end
            if expo > 0
                push!(fac_exp, (i + 1, expo))
            end
        end
        m == 1 && break
    end
    return fac_exp
end

const superchars = ["\u2070", "\u00b9", "\u00b2", "\u00b3", "\u2074",
                    "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"]
""" Express a positive integer as Unicode superscript digit characters """
super(n::Integer) = prod(superchars[i + 1] for i in reverse(digits(n)))

arr = aupto(2^53)

println("First 50 Jordan–Pólya numbers:")
foreach(p -> print(rpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), enumerate(arr[1:50]))

println("\nThe largest Jordan–Pólya number before 100 million: ", arr[findlast(<(100_000_000), arr)])

for n in [800, 1800, 2800, 3800]
    print("\nThe $(n)th Jordan-Pólya number is: $(arr[n])\n= ")
    println(join(map(t -> "$(t[1])!$(t[2] > 1 ? super(t[2]) : "")",
       factor_as_factorials(arr[n])), " x "))
end
