function allpalindromics(s)
    list, len = String[], length(s)
    for i in 1:len-1, j in i+1:len
        substr = s[i:j]
        if substr == reverse(substr)
            push!(list, substr)
        end
    end
    return list
end

for teststring in ["babaccd", "rotator", "reverse", "forever", "several", "palindrome"]
    list = sort!(allpalindromics(teststring), lt = (x, y) -> length(x) < length(y))
    println(isempty(list) ? "No palindromes of 2 or more letters found in \"$teststring." :
        "The longest palindromic substring of $teststring is: \"",
        join(list[findall(x -> length(x) == length(list[end]), list)], "\" or \""), "\"")
end
