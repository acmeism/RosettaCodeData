function filter(b,a,input)
    local out = {}
    for i=1,table.getn(input) do
        local tmp = 0
        local j = 0
        out[i] = 0

        for j=1,table.getn(b) do
            if i - j < 0 then
                --continue
            else
                tmp = tmp + b[j] * input[i - j + 1]
            end
        end

        for j=2,table.getn(a) do
            if i - j < 0 then
                --continue
            else
                tmp = tmp - a[j] * out[i - j + 1]
            end
        end

        tmp = tmp / a[1]
        out[i] = tmp
    end
    return out
end

function main()
    local sig = {
        -0.917843918645, 0.141984778794, 1.20536903482,  0.190286794412,-0.662370894973,
        -1.00700480494, -0.404707073677, 0.800482325044, 0.743500089861, 1.01090520172,
         0.741527555207, 0.277841675195, 0.400833448236,-0.2085993586,  -0.172842103641,
        -0.134316096293, 0.0259303398477,0.490105989562, 0.549391221511, 0.9047198589
    }

    --Constants for a Butterworth filter (order 3, low pass)
    local a = {1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17}
    local b = {0.16666667, 0.5, 0.5, 0.16666667}

    local result = filter(b,a,sig)
    for i=1,table.getn(result) do
        io.write(result[i] .. ", ")
    end
    print()

    return nil
end

main()
