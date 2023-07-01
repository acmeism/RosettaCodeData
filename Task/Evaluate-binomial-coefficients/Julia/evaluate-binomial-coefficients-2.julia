function binom(n::Integer, k::Integer)
    n ≥ k || return 0 # short circuit base cases
    (n == 1 || k == 0) && return 1

    n * binom(n - 1, k - 1) ÷ k
end

@show binom(5, 3)
