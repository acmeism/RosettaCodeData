Nth(x::Integer) = if x % 100 ∈ [11, 12, 13] "th" else ["th", "st", "nd", "rd", "th"][min(x % 10 + 1, 5)] end
NthA(x::Integer) = "$(x)'$(Nth(x)) "
[0:25..., 250:265..., 1000:1025...] .|> NthA .|> print;
