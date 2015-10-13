function striplinecomment{T<:String,U<:String}(a::T, cchars::U="#;")
    b = strip(a)
    0 < length(cchars) || return b
    for c in cchars
        r = Regex(@sprintf "\\%c.*" c)
        b = replace(b, r, "")
    end
    strip(b)
end

tests = {"apples, pears # and bananas",
         "apples, pears ; and bananas",
         "  apples, pears & bananas   ",
         " # "}

for t in tests
    s = striplinecomment(t)
    println("Testing \"", t, "\":")
    println("    \"", s, "\"")
end
