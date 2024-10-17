function B10(n)
    for i in Int128(1):typemax(Int128)
        q, b10, place = i, zero(Int128), one(Int128)
        while q > 0
            q, r = divrem(q, 2)
            if r != 0
                b10 += place
            end
            place *= 10
        end
        if b10 % n == 0
            return b10
        end
    end
end

for n in [1:10; 95:105; [297, 576, 891, 909, 1998, 2079, 2251, 2277, 2439, 2997, 4878]]
    i = B10(n)
    println("B10($n) = $n * $(div(i, n)) = $i")
end
