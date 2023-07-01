def initN
    n = Array.new(15){Array.new(11, ' ')}
    for i in 1..15
        n[i - 1][5] = 'x'
    end
    return n
end

def horiz(n, c1, c2, r)
    for c in c1..c2
        n[r][c] = 'x'
    end
end

def verti(n, r1, r2, c)
    for r in r1..r2
        n[r][c] = 'x'
    end
end

def diagd(n, c1, c2, r)
    for c in c1..c2
        n[r+c-c1][c] = 'x'
    end
end

def diagu(n, c1, c2, r)
    for c in c1..c2
        n[r-c+c1][c] = 'x'
    end
end

def initDraw
    draw = []

    draw[1] = lambda do |n| horiz(n, 6, 10, 0) end
    draw[2] = lambda do |n| horiz(n, 6, 10, 4) end
    draw[3] = lambda do |n| diagd(n, 6, 10, 0) end
    draw[4] = lambda do |n| diagu(n, 6, 10, 4) end
    draw[5] = lambda do |n|
        draw[1].call(n)
        draw[4].call(n)
    end
    draw[6] = lambda do |n| verti(n, 0, 4, 10) end
    draw[7] = lambda do |n|
        draw[1].call(n)
        draw[6].call(n)
    end
    draw[8] = lambda do |n|
        draw[2].call(n)
        draw[6].call(n)
    end
    draw[9] = lambda do |n|
        draw[1].call(n)
        draw[8].call(n)
    end

    draw[10] = lambda do |n| horiz(n, 0, 4, 0) end
    draw[20] = lambda do |n| horiz(n, 0, 4, 4) end
    draw[30] = lambda do |n| diagu(n, 0, 4, 4) end
    draw[40] = lambda do |n| diagd(n, 0, 4, 0) end
    draw[50] = lambda do |n|
        draw[10].call(n)
        draw[40].call(n)
    end
    draw[60] = lambda do |n| verti(n, 0, 4, 0) end
    draw[70] = lambda do |n|
        draw[10].call(n)
        draw[60].call(n)
    end
    draw[80] = lambda do |n|
        draw[20].call(n)
        draw[60].call(n)
    end
    draw[90] = lambda do |n|
        draw[10].call(n)
        draw[80].call(n)
    end

    draw[100] = lambda do |n| horiz(n, 6, 10, 14) end
    draw[200] = lambda do |n| horiz(n, 6, 10, 10) end
    draw[300] = lambda do |n| diagu(n, 6, 10, 14) end
    draw[400] = lambda do |n| diagd(n, 6, 10, 10) end
    draw[500] = lambda do |n|
        draw[100].call(n)
        draw[400].call(n)
    end
    draw[600] = lambda do |n| verti(n, 10, 14, 10) end
    draw[700] = lambda do |n|
        draw[100].call(n)
        draw[600].call(n)
    end
    draw[800] = lambda do |n|
        draw[200].call(n)
        draw[600].call(n)
    end
    draw[900] = lambda do |n|
        draw[100].call(n)
        draw[800].call(n)
    end

    draw[1000] = lambda do |n| horiz(n, 0, 4, 14) end
    draw[2000] = lambda do |n| horiz(n, 0, 4, 10) end
    draw[3000] = lambda do |n| diagd(n, 0, 4, 10) end
    draw[4000] = lambda do |n| diagu(n, 0, 4, 14) end
    draw[5000] = lambda do |n|
        draw[1000].call(n)
        draw[4000].call(n)
    end
    draw[6000] = lambda do |n| verti(n, 10, 14, 0) end
    draw[7000] = lambda do |n|
        draw[1000].call(n)
        draw[6000].call(n)
    end
    draw[8000] = lambda do |n|
        draw[2000].call(n)
        draw[6000].call(n)
    end
    draw[9000] = lambda do |n|
        draw[1000].call(n)
        draw[8000].call(n)
    end

    return draw
end

def printNumeral(n)
    for a in n
        for b in a
            print b
        end
        print "\n"
    end
    print "\n"
end

draw = initDraw()
for number in [0, 1, 20, 300, 4000, 5555, 6789, 9999]
    n = initN()
    print number, ":\n"

    thousands = (number / 1000).floor
    number = number % 1000

    hundreds = (number / 100).floor
    number = number % 100

    tens = (number / 10).floor
    ones = number % 10

    if thousands > 0 then
        draw[thousands * 1000].call(n)
    end
    if hundreds > 0 then
        draw[hundreds * 100].call(n)
    end
    if tens > 0 then
        draw[tens * 10].call(n)
    end
    if ones > 0 then
        draw[ones].call(n)
    end
    printNumeral(n)
end
