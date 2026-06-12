""" forward binomial transform """
binomial_transform(seq) =
    [sum(binomial(n, k) * seq[k+1] for k in 0:n) for n in 0:length(seq)-1]

""" inverse binomial transform """
function inverse_binomial_transform(seq)
    return [sum((-1)^(n - k) * binomial(n, k) * seq[k+1] for k in 0:n) for n in 0:length(seq)-1]
end

const test_sequences = [
    "Catalan number sequence" => [
        1,
        1,
        2,
        5,
        14,
        42,
        132,
        429,
        1430,
        4862,
        16796,
        58786,
        208012,
        742900,
        2674440,
        9694845,
        35357670,
        129644790,
        477638700,
        1767263190,
    ],
    "Prime flip-flop sequence" =>
        [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    "Fibonacci number sequence" => [
        0,
        1,
        1,
        2,
        3,
        5,
        8,
        13,
        21,
        34,
        55,
        89,
        144,
        233,
        377,
        610,
        987,
        1597,
        2584,
        4181,
    ],
    "Padovan number sequence" =>
        [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37],
]

for (s, a) in test_sequences
    println("\n$s:\n", join(a, " "))
    println("Forward binomial transform:\n", join(binomial_transform(a), " "))
    println("Inverse binomial transform:\n", join(inverse_binomial_transform(a), " "))
    println("Re-inverted:\n", join(inverse_binomial_transform(binomial_transform(a)), " "))
end
