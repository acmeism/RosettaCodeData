function extendedsqrt(x)
    try sqrt(x)
    catch
        if x isa Number
            sqrt(complex(x, 0))
        else
            throw(DomainError())
        end
    end
end

@show extendedsqrt(1)   # 1
@show extendedsqrt(-1)  # 0.0 + 1.0im
@show extendedsqrt('x') # ERROR: DomainError
