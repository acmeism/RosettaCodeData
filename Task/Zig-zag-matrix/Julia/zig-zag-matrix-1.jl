function zigzag_matrix(n::Int)
    matrix = zeros(Int, n, n)
    x, y = 1, 1
    for i = 0:(n*n-1)
        matrix[y,x] = i
        if (x + y) % 2 == 0
            # Even stripes
            if x < n
                x += 1
                y -= (y > 1)
            else
                y += 1
            end
        else
            # Odd stripes
            if y < n
                x -= (x > 1)
                y += 1
            else
                x += 1
            end
        end
    end
    return matrix
end
