using Printf

function exerciselogic(a::Bool, b::Bool)
    st = @sprintf " %5s" a
    st *= @sprintf " %5s" b
    st *= @sprintf " %5s" ~a
    st *= @sprintf " %5s" a | b
    st *= @sprintf " %5s" a & b
    st *= @sprintf " %5s" a $ b
end

println("Julia's logical operations on Bool:")
println("   a     b    not   or    and   xor")
for a in [true, false], b in [true, false]
    println(exerciselogic(a, b))
end
