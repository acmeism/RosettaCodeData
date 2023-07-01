K = 7.9e9
N0 = 27
ACTUAL = [
    27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,
    61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023, 2820,
    4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615, 24522, 28273,
    31491, 34933, 37552, 40540, 43105, 45177, 60328, 64543, 67103,
    69265, 71332, 73327, 75191, 75723, 76719, 77804, 78812, 79339,
    80132, 80995, 82101, 83365, 85203, 87024, 89068, 90664, 93077,
    95316, 98172, 102133, 105824, 109695, 114232, 118610, 125497,
    133852, 143227, 151367, 167418, 180096, 194836, 213150, 242364,
    271106, 305117, 338133, 377918, 416845, 468049, 527767, 591704,
    656866, 715353, 777796, 851308, 928436, 1000249, 1082054, 1174652
]

def f(r)
    sq = 0.0
    len = ACTUAL.length
    for i in 1 .. len
        j = i - 1
        eri = Math.exp(r * j)
        guess = (N0 * eri) / (1 + N0 * (eri - 1.0) / K)
        diff = guess - ACTUAL[j]
        sq += diff * diff
    end
    return sq
end

def solve(fn, guess=0.5, epsilon=0.0)
    delta = guess ? guess : 1.0
    f0 = send(fn, guess)
    factor = 2.0
    while delta > epsilon and guess != guess - delta
        nf = send(fn, guess - delta)
        if nf < f0 then
            f0 = nf
            guess -= delta
        else
            nf = send(fn, guess + delta)
            if nf < f0 then
                f0 = nf
                guess += delta
            else
                factor = 0.5
            end
        end

        delta *= factor
    end
    return guess
end

def main
    r = solve(:f)
    r0 = Math.exp(12.0 * r)
    print "r = ", r, ", R0 = ", r0, "\n"
end

main()
