function B10(n)
    n == 1 && return one(Int128)
    num, count, ten = n + 1, 0, 1
    val, pow = zeros(Int, num), zeros(Int, num)
    for i in 1:n
        val[i + 1] = ten
        for j in 1:num
            k = (j + ten - 1) % n + 1
            if pow[j] != 0 && pow[k] == 0 && pow[j] != i
                pow[k] = i
            end
        end
        if pow[ten + 1] == 0
            pow[ten + 1] = i
        end
        ten = (10 * ten) % n
        (pow[1] != 0) && break
    end
    res, i = "", n
    while i != 0
        pm = pow[i % n + 1]
        if count > pm
            res *= "0"^(count - pm)
        end
        count = pm - 1
        res *= "1"
        i = (n + i - val[pm + 1]) % n
    end
    if count > 0
        res *= "0"^count
    end
    return parse(Int128, res)
end

const tests = [1:10; 95:105; [97, 576, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878, 9999, 2 * 9999]]

@time for n in tests
    i = B10(n)
    println("B10($n) = $n * $(div(i, n)) = $i")
end
