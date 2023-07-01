function ant(width, height)
    y, x = fld(height, 2), fld(width, 2)
    M = falses(height, width)

    dir = im
    for i in 0:100000
        x in 1:width && y in 1:height || break
        dir *= M[y, x] ? im : -im
        M[y, x] = !M[y, x]
        x, y = reim(x + im * y + dir)
    end

    for row in 1:size(M,1)
        println(mapreduce(x -> x ? 'x' : '.', *, M[row,:]))
    end
end

ant(100, 100)
