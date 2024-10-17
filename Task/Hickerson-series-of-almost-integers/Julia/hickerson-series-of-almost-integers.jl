function makehickerson{T<:Real}(x::T)
    n = 0
    h = one(T)/2x
    function hickerson()
        n += 1
        h *= n/x
    end
end

function reporthickerson{T<:Real,U<:Integer}(a::T, nmax::U)
    h = makehickerson(a)
    hgm = makehickerson(prevfloat(a))
    hgp = makehickerson(nextfloat(a))

    println()
    print("Performing calculations using ", typeof(a))
    println(", which has ", precision(a), "-bit precision.")
    for i in 1:nmax
        x = h()
        xm = hgm()
        xp = hgp()
        y = ifloor(10x)
        ym = ifloor(10xm)
        yp = ifloor(10xp)
        println()
        println("Hickerson series result for n = ", i)
        println(@sprintf("    ->  %25.4f ", xm))
        println(@sprintf("    0>  %25.4f ", x))
        println(@sprintf("    +>  %25.4f ", xp))
        isprecok =
        isint =
        if ym == y == yp
            print("The precision is adequate, ")
            if  digits(y)[1] in [0, 9]
                println("and the result is an almost integer.")
            else
                println("but the result is not an almost integer.")
            end
        else
            println("The precision is inadequate for a definite result.")
        end
    end
end

a = log(big(2.0))
reporthickerson(a, 17)

a = log(2.0)
reporthickerson(a, 17)
