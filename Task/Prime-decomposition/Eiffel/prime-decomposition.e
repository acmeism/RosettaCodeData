class
    PRIME_DECOMPOSITION

feature

    factor (p: INTEGER): ARRAY [INTEGER]
            -- Prime decomposition of 'p'.
        require
            p_positive: p > 0
        local
            div, i, next, rest: INTEGER
        do
            create Result.make_empty
            if p = 1 then
                Result.force (1, 1)
            end
            div := 2
            next := 3
            rest := p
            from
                i := 1
            until
                rest = 1
            loop
                from
                until
                    rest \\ div /= 0
                loop
                    Result.force (div, i)
                    rest := (rest / div).floor
                    i := i + 1
                end
                div := next
                next := next + 2
            end
        ensure
            is_divisor: across Result as r all p \\ r.item = 0 end
            is_prime: across Result as r all prime (r.item) end
        end
