immutable Point{T<:FloatingPoint}
    x::T
    y::T
end

immutable Circle{T<:FloatingPoint}
    c::Point{T}
    r::T
end
Circle{T<:FloatingPoint}(a::Point{T}) = Circle(a, zero(T))

using AffineTransforms

function circlepoints{T<:FloatingPoint}(a::Point{T}, b::Point{T}, r::T)
    cp = Circle{T}[]
    r >= 0 || return (cp, "No Solution, Negative Radius")
    if a == b
        if abs(r) < 2eps(zero(T))
            return (push!(cp, Circle(a)), "Point Solution, Zero Radius")
        else
            return (cp, "Infinite Solutions, Indefinite Center")
        end
    end
    ca = Complex(a.x, a.y)
    cb = Complex(b.x, b.y)
    d = (ca + cb)/2
    tfd = tformtranslate([real(d), imag(d)])
    tfr = tformrotate(angle(cb-ca))
    tfm = tfd*tfr
    u = abs(cb-ca)/2
    r-u > -5eps(r) || return(cp, "No Solution, Radius Too Small")
    if r-u < 5eps(r)
        push!(cp, Circle(apply(Point, tfm*[0.0, 0.0]), r))
        return return (cp, "Single Solution, Degenerate Centers")
    end
    v = sqrt(r^2 - u^2)
    for w in [v, -v]
        push!(cp, Circle(apply(Point, tfm*[0.0, w]), r))
    end
    return (cp, "Two Solutions")
end
