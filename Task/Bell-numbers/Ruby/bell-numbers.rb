def bellTriangle(n)
    tri = Array.new(n)
    for i in 0 .. n - 1 do
        tri[i] = Array.new(i)
        for j in 0 .. i - 1 do
            tri[i][j] = 0
        end
    end
    tri[1][0] = 1
    for i in 2 .. n - 1 do
        tri[i][0] = tri[i - 1][i - 2]
        for j in 1 .. i - 1 do
            tri[i][j] = tri[i][j - 1] + tri[i - 1][j - 1]
        end
    end
    return tri
end

def main
    bt = bellTriangle(51)
    puts "First fifteen and fiftieth Bell numbers:"
    for i in 1 .. 15 do
        puts "%2d: %d" % [i, bt[i][0]]
    end
    puts "50: %d" % [bt[50][0]]
    puts

    puts "The first ten rows of Bell's triangle:"
    for i in 1 .. 10 do
        puts bt[i].inspect
    end
end

main()
