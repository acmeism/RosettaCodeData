type FigureFigure{T<:Integer}
    r::Array{T,1}
    rnmax::T
    snmax::T
    snext::T
end

function grow!{T<:Integer}(ff::FigureFigure{T}, rnmax::T=100)
    ff.rnmax < rnmax || return nothing
    append!(ff.r, zeros(T, (rnmax-ff.rnmax)))
    snext = ff.snext
    for i in (ff.rnmax+1):rnmax
        ff.r[i] = ff.r[i-1] + snext
        snext += 1
        while snext in ff.r
            snext += 1
        end
    end
    ff.rnmax = rnmax
    ff.snmax = ff.r[end] - rnmax
    ff.snext = snext
    return nothing
end

function FigureFigure{T<:Integer}(rnmax::T=10)
    ff = FigureFigure([1], 1, 0, 2)
    grow!(ff, rnmax)
    return ff
end

function FigureFigure{T<:Integer}(rnmax::T, snmax::T)
    ff = FigureFigure(rnmax)
    while ff.snmax < snmax
        grow!(ff, 2ff.rnmax)
    end
    return ff
end

function make_ffr{T<:Integer}(nmax::T=10)
    ff = FigureFigure(nmax)
    function ffr{T<:Integer}(n::T)
        if n > ff.rnmax
            grow!(ff, 2n)
        end
        ff.r[n]
    end
end

function make_ffs{T<:Integer}(nmax::T=100)
    ff = FigureFigure(13, nmax)
    function ffs{T<:Integer}(n::T)
        while ff.snmax < n
            grow!(ff, 2ff.rnmax)
        end
        s = n
        for r in ff.r
            r <= s || return s
            s += 1
        end
    end
end
