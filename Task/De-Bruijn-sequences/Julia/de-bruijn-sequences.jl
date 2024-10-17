function debruijn(k::Integer, n::Integer)
    alphabet = b"0123456789abcdefghijklmnopqrstuvwxyz"[1:k]
    a = zeros(UInt8, k * n)
    seq = UInt8[]

    function db(t, p)
        if t > n
            if n % p == 0
                append!(seq, a[2:p+1])
            end
        else
            a[t + 1] = a[t - p + 1]
            db(t + 1, p)
            for j in a[t-p+1]+1:k-1
                a[t + 1] = j
                db(t + 1, t)
            end
        end
    end

    db(1, 1)
    return String([alphabet[i + 1] for i in vcat(seq, seq[1:n-1])])
end

function verifyallPIN(str, k, n, deltaposition=0)
    if deltaposition != 0
        str = str[1:deltaposition-1] * "." * str[deltaposition+1:end]
    end
    result = true
    for i in 1:k^n-1
        pin = string(i, pad=n)
        if !occursin(pin, str)
            println("PIN $pin does not occur in the sequence.")
            result = false
        end
    end
    println("The sequence does ", result ? "" : "not ", "contain all PINs.")
end

const s = debruijn(10, 4)
println("The length of the sequence is $(length(s)). The first 130 digits are:\n",
    s[1:130], "\nand the last 130 digits are:\n", s[end-130:end])
print("Testing sequence: "), verifyallPIN(s, 10, 4)
print("Testing the reversed sequence: "), verifyallPIN(reverse(s), 10, 4)
println("\nAfter replacing 4444th digit with \'.\':"), verifyallPIN(s, 10, 4, 4444)
