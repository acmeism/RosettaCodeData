const teststrings = [
    "",
    """"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln """,
    "..1111111111111111111111111111111111111111111111111111111111111117777888",
    """I never give 'em hell, I just tell the truth, and they think it's hell. """,
    "                                                    --- Harry S Truman  "]

function collapse(s)
    len = length(s)
    if len < 2
        return s, len, s, len
    end
    result = last = s[1]
    for c in s[2:end]
        if c != last
            last = c
            result *= c
        end
    end
    return s, len, result, length(result)
end

function testcollapse(arr)
    for s in arr
        (s1, len1, s2, len2) = collapse(s)
        println("«««$s1»»» (length $len1)\n    collapses to:\n«««$s2»»» (length $len2).\n")
    end
end

testcollapse(teststrings)
