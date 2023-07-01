using Printf

function showvampire{T<:Integer}(i::T, n::T, fangs::Array{T,2})
    s = @sprintf "%6d  %14d %s\n" i n join(fangs[1,:], "\u00d7")
    for i in 2:size(fangs)[1]
        s *= " "^23*join(fangs[i,:], "\u00d7")*"\n"
    end
    return s
end

vgoal = 25
vcnt = 0
dcnt = 0
println("Finding the first ", vgoal, " vampire numbers.")
println("     N         Vampire Fangs")
while vcnt < vgoal
    dcnt += 2
    for i in (10^(dcnt-1)):(10^dcnt-1)
        (isvampire, fangs) = vampirefangs(i)
        isvampire || continue
        vcnt += 1
        print(showvampire(vcnt, i, fangs))
        vcnt < vgoal || break
    end
end

test = [16758243290880, 24959017348650, 14593825548650]
println()
println("Checking a few numbers.")
println("     N         Vampire Fangs")
for (i, v) in enumerate(test)
    (isvampire, fangs) = vampirefangs(v)
    if isvampire
        print(showvampire(i, v, fangs))
    else
        println(@sprintf "%6d  %14d is not a vampire" i v)
    end
end
