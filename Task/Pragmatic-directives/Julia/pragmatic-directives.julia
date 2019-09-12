x = rand(100, 100)
y = rand(100, 100)

@inbounds begin
    for i = 1:100
        for j = 1:100
            x[i, j] *= y[i, j]
            y[i, j] += x[i, j]
        end
    end
end
