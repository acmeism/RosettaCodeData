""" Lempel-Ziv Complexity Calculation (Wikipedia algorithm) """
function lempel_ziv_complexity(sequence)
    isempty(sequence) && return 0, ""

    complexity, i, u, v, vmax, n = 1, 0, 1, 1, 1, length(sequence)
    history = sequence[begin] * '.'
    while u + v <= n
        if sequence[i+v] == sequence[u+v]
            v += 1
        else
            vmax = max(v, vmax)
            v = 1
            i += 1
            if i == u
                history *= sequence[(i+1):(u+vmax)] * '.'
                complexity += 1
                u += vmax
                i = 0
                vmax = 1
            end
        end
    end
    if v != 1
        complexity += 1
        history *= sequence[(u+1):end]
    end
    return complexity, history
end

function testLZ() # as per revised requirements
    tests = [
        ("AZSEDRFTGYGUJIJOKB", 16),
        ("ABCABCABCABCABCABC", 4),
        ("111011111001111011111001", 6),
        ("101001010010111110", 5),
        ("1001111011000010", 6),
        ("1010101010", 3),
        ("1010101010101010", 3),
        ("1001111011000010000010", 7),
        ("100111101100001000001010", 8),
        ("0001101001000101", 6),
        ("1111111", 2),
        ("0001", 2),
        ("010", 3),
        ("1", 1),
        ("", 0),
        ("01011010001101110010", 7),
        ("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26),
        ("HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!", 11),
        ("0001101001000101", 6),
    ]
    println(rpad("String", 42), " LZ Complexity    Exhaustive History\n", "=" ^ 95)
    for (test, ans) in tests
        lzc, history = lempel_ziv_complexity(test)
        @assert lzc == ans "Test failed for input: $test. Expected $ans, got $lzc"
        println(rpad(test, 52), lpad(string(lzc), 4), "    ", history)
    end
    println("All tests passed.")
end

testLZ()
