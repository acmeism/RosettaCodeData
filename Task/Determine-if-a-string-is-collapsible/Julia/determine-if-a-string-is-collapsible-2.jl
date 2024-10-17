const teststrings = [
    "",
    """"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln """,
    "..1111111111111111111111111111111111111111111111111111111111111117777888",
    """I never give 'em hell, I just tell the truth, and they think it's hell. """,
    "                                                    --- Harry S Truman  "]

collapse(s) = (t = isempty(s) ? "" : s[1:1]; for c in s if c != t[end] t *= c end; end; t)

for s in teststrings
    n, t = length(s), collapse(s)
    println("«««$s»»» (length $n)\n    collapses to:\n«««$t»»» (length $(length(t))).\n")
end
