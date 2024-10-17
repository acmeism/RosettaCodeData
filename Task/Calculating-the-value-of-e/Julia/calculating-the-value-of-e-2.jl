for F in (Float16, Float32, Float64, BigFloat)
    println(NeperConst{F}())
end
