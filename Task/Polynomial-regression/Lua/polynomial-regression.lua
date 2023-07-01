function eval(a,b,c,x)
    return a + (b + c * x) * x
end

function regression(xa,ya)
    local n = #xa

    local xm = 0.0
    local ym = 0.0
    local x2m = 0.0
    local x3m = 0.0
    local x4m = 0.0
    local xym = 0.0
    local x2ym = 0.0

    for i=1,n do
        xm = xm + xa[i]
        ym = ym + ya[i]
        x2m = x2m + xa[i] * xa[i]
        x3m = x3m + xa[i] * xa[i] * xa[i]
        x4m = x4m + xa[i] * xa[i] * xa[i] * xa[i]
        xym = xym + xa[i] * ya[i]
        x2ym = x2ym + xa[i] * xa[i] * ya[i]
    end
    xm = xm / n
    ym = ym / n
    x2m = x2m / n
    x3m = x3m / n
    x4m = x4m / n
    xym = xym / n
    x2ym = x2ym / n

    local sxx = x2m - xm * xm
    local sxy = xym - xm * ym
    local sxx2 = x3m - xm * x2m
    local sx2x2 = x4m - x2m * x2m
    local sx2y = x2ym - x2m * ym

    local b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    local c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    local a = ym - b * xm - c * x2m

    print("y = "..a.." + "..b.."x + "..c.."x^2")

    for i=1,n do
        print(string.format("%2d %3d  %3d", xa[i], ya[i], eval(a, b, c, xa[i])))
    end
end

local xa = {0, 1,  2,  3,  4,  5,   6,   7,   8,   9,  10}
local ya = {1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321}
regression(xa, ya)
