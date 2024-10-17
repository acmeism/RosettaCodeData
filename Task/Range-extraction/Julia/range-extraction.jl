function sprintfrange{T<:Integer}(a::Array{T,1})
    len = length(a)
    0 < len || return ""
    dropme = falses(len)
    dropme[2:end-1] = Bool[a[i-1]==a[i]-1 && a[i+1]==a[i]+1 for i in 2:(len-1)]
    s = [string(i) for i in a]
    s[dropme] = "X"
    s = join(s, ",")
    replace(s, r",[,X]+,", "-")
end

testa = [ 0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
         15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
         25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
         37, 38, 39]

println("Testing range-style formatting.")
println("   ", testa, "\n       =>\n   ", sprintfrange(testa))
