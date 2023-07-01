function initN()
    local n = {}
    for i=1,15 do
        n[i] = {}
        for j=1,11 do
            n[i][j] = " "
        end
        n[i][6] = "x"
    end
    return n
end

function horiz(n, c1, c2, r)
    for c=c1,c2 do
        n[r+1][c+1] = "x"
    end
end

function verti(n, r1, r2, c)
    for r=r1,r2 do
        n[r+1][c+1] = "x"
    end
end

function diagd(n, c1, c2, r)
    for c=c1,c2 do
        n[r+c-c1+1][c+1] = "x"
    end
end

function diagu(n, c1, c2, r)
    for c=c1,c2 do
        n[r-c+c1+1][c+1] = "x"
    end
end

function initDraw()
    local draw = {}

    draw[1] = function(n) horiz(n, 6, 10, 0) end
    draw[2] = function(n) horiz(n, 6, 10, 4) end
    draw[3] = function(n) diagd(n, 6, 10, 0) end
    draw[4] = function(n) diagu(n, 6, 10, 4) end
    draw[5] = function(n) draw[1](n) draw[4](n) end
    draw[6] = function(n) verti(n, 0, 4, 10) end
    draw[7] = function(n) draw[1](n) draw[6](n) end
    draw[8] = function(n) draw[2](n) draw[6](n) end
    draw[9] = function(n) draw[1](n) draw[8](n) end

    draw[10] = function(n) horiz(n, 0, 4, 0) end
    draw[20] = function(n) horiz(n, 0, 4, 4) end
    draw[30] = function(n) diagu(n, 0, 4, 4) end
    draw[40] = function(n) diagd(n, 0, 4, 0) end
    draw[50] = function(n) draw[10](n) draw[40](n) end
    draw[60] = function(n) verti(n, 0, 4, 0) end
    draw[70] = function(n) draw[10](n) draw[60](n) end
    draw[80] = function(n) draw[20](n) draw[60](n) end
    draw[90] = function(n) draw[10](n) draw[80](n) end

    draw[100] = function(n) horiz(n, 6, 10, 14) end
    draw[200] = function(n) horiz(n, 6, 10, 10) end
    draw[300] = function(n) diagu(n, 6, 10, 14) end
    draw[400] = function(n) diagd(n, 6, 10, 10) end
    draw[500] = function(n) draw[100](n) draw[400](n) end
    draw[600] = function(n) verti(n, 10, 14, 10) end
    draw[700] = function(n) draw[100](n) draw[600](n) end
    draw[800] = function(n) draw[200](n) draw[600](n) end
    draw[900] = function(n) draw[100](n) draw[800](n) end

    draw[1000] = function(n) horiz(n, 0, 4, 14) end
    draw[2000] = function(n) horiz(n, 0, 4, 10) end
    draw[3000] = function(n) diagd(n, 0, 4, 10) end
    draw[4000] = function(n) diagu(n, 0, 4, 14) end
    draw[5000] = function(n) draw[1000](n) draw[4000](n) end
    draw[6000] = function(n) verti(n, 10, 14, 0) end
    draw[7000] = function(n) draw[1000](n) draw[6000](n) end
    draw[8000] = function(n) draw[2000](n) draw[6000](n) end
    draw[9000] = function(n) draw[1000](n) draw[8000](n) end

    return draw
end

function printNumeral(n)
    for i,v in pairs(n) do
        for j,w in pairs(v) do
            io.write(w .. " ")
        end
        print()
    end
    print()
end

function main()
    local draw = initDraw()
    for i,number in pairs({0, 1, 20, 300, 4000, 5555, 6789, 9999}) do
        local n = initN()
        print(number..":")
        local thousands = math.floor(number / 1000)
        number = number % 1000
        local hundreds = math.floor(number / 100)
        number = number % 100
        local tens = math.floor(number / 10)
        local ones = number % 10
        if thousands > 0 then
            draw[thousands * 1000](n)
        end
        if hundreds > 0 then
            draw[hundreds * 100](n)
        end
        if tens > 0 then
            draw[tens * 10](n)
        end
        if ones > 0 then
            draw[ones](n)
        end
        printNumeral(n)
    end
end

main()
