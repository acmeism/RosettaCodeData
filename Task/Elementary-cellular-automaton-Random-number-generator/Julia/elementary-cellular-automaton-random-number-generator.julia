function evolve(state, rule, N=64)
    B(x) = UInt64(1) << x
    for p in 0:9
        b = UInt64(0)
        for q in 7:-1:0
            st = UInt64(state)
            b |= (st & 1) << q
            state = UInt64(0)
            for i in 0:N-1
                t1 = (i > 0) ? st >> (i - 1) : st >> (N - 1)
                t2 = (i == 0) ? st << 1 : (i == 1) ? st << (N - 1) : st << (N + 1 - i)
                if UInt64(rule) & B(7 & (t1 | t2)) != 0
                    state |= B(i)
                end
            end
        end
        print("$b ")
    end
    println()
end

evolve(1, 30)
