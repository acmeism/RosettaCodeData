let
    smallprimes = [2, 3, 5, 7, 11, 13, 17] # 0 <= all of these primes <= 18
    paired_digit_sums(n) = (d = digits(n); [sum(p) for p in zip(d[1:end-1], d[2:end])])
    isstrangeplus(n) = all(x -> x ∈ smallprimes, paired_digit_sums(n))

    printed = 0
    for n in 100:500
        isstrangeplus(n) && print(n, (printed += 1) % 13 == 0 ? "\n" : "  ")
    end
end
