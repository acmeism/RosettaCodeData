function circle(x, y, c, r)
    return (r * r) >= (x * x) / 4 + ((y - c) * (y - c))
end

function pixel(x, y, r)
    if circle(x, y, -r / 2, r / 6) then
        return '#'
    end
    if circle(x, y, r / 2, r / 6) then
        return '.'
    end
    if circle(x, y, -r / 2, r / 2) then
        return '.'
    end
    if circle(x, y, r / 2, r / 2) then
        return '#'
    end
    if circle(x, y, 0, r) then
        if x < 0 then
            return '.'
        else
            return '#'
        end
    end
    return ' '
end

function yinYang(r)
    for y=-r,r do
        for x=-2*r,2*r do
            io.write(pixel(x, y, r))
        end
        print()
    end
end

yinYang(18)
