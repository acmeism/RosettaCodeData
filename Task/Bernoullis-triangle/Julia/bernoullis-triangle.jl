function bernoullitriangle(rows::T, spacing = 6) where T <: Integer
    for n in 0:rows-1
        print("\n", " "^(spacing * (rows - n) ÷ 2), "1")
        for k in 1:n
            print(lpad(sum(binomial(n, p) for p in 0:min(k,n)), spacing))
        end
    end
end

bernoullitriangle(15)
