function init_zc()
    zc = zeros(Int, 999)
    for x in 1:9
        zc[x] = 2       # 00x
        zc[10*x] = 2    # 0x0
        zc[100*x] = 2   # x00
        for y in 10:10:90
            zc[y+x] = 1         # 0yx
            zc[10*y+x] = 1      # y0x
            zc[10*(y+x)] = 1    # yx0
        end
    end
    return zc
end

function meanfactorialzeros(N = 50000, verbose = true)
    zc = init_zc()
    rfs = [1]

    total, trail, first, firstratio = 0.0, 1, 0, 0.0

    for f in 2:N
        carry, d999, zeroes = 0, 0, (trail - 1) * 3
        j, l = trail, length(rfs)
        while j <= l || carry != 0
            if j <= l
                carry = (rfs[j]) * f + carry
            end
            d999 = carry % 1000
            if j <= l
                rfs[j] = d999
            else
                push!(rfs, d999)
            end
            zeroes += (d999 == 0) ? 3 : zc[d999]
            carry ÷= 1000
            j += 1
        end
        while rfs[trail] == 0
            trail += 1
        end
        # d999 = quick correction for length and zeroes:
        d999 = rfs[end]
        d999 = d999 < 100 ? d999 < 10 ? 2 : 1 : 0
        zeroes -= d999
        digits = length(rfs) * 3 - d999
        total += zeroes / digits
        ratio = total / f
        if ratio >= 0.16
           first = 0
           firstratio = 0.0
        elseif first == 0
            first = f
            firstratio = ratio
        end
        if f in [100, 1000, 10000]
            verbose && println("Mean proportion of zero digits in factorials to $f is $ratio")
        end
    end
    verbose && println("The mean proportion dips permanently below 0.16 at $first.")
end

meanfactorialzeros(100, false)
@time meanfactorialzeros()
