def filter(a,b,signal)
    result = Array.new(signal.length(), 0.0)
    for i in 0..signal.length()-1 do
        tmp = 0.0
        for j in 0 .. b.length()-1 do
            if i - j < 0 then next end
            tmp += b[j] * signal[i - j]
        end
        for j in 1 .. a.length()-1 do
            if i - j < 0 then next end
            tmp -= a[j] * result[i - j]
        end
        tmp /= a[0]
        result[i] = tmp
    end
    return result
end

def main
    a = [1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17]
    b = [0.16666667, 0.5, 0.5, 0.16666667]
    signal = [
        -0.917843918645,  0.141984778794, 1.20536903482,   0.190286794412,
        -0.662370894973, -1.00700480494, -0.404707073677,  0.800482325044,
         0.743500089861,  1.01090520172,  0.741527555207,  0.277841675195,
         0.400833448236, -0.2085993586,  -0.172842103641, -0.134316096293,
         0.0259303398477, 0.490105989562, 0.549391221511,  0.9047198589
    ]

    result = filter(a,b,signal)
    for i in 0 .. result.length() - 1 do
        print "%11.8f" % [result[i]]
        if (i + 1) % 5 == 0 then
            print "\n"
        else
            print ", "
        end
    end
end

main()
