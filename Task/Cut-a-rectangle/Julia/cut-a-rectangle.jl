const count = [0]
const dir = [[0, -1], [-1, 0], [0, 1], [1, 0]]

function walk(y, x, h, w, grid, len, next)
    if y == 0 || y == h || x == 0 || x == w
        count[1] += 2
        return
    end
    t = y * (w + 1) + x
    grid[t + 1] += UInt8(1)
    grid[len - t + 1] += UInt8(1)
    for i in 1:4
        if grid[t + next[i] + 1] == 0
            walk(y + dir[i][1], x + dir[i][2], h, w, grid, len, next)
        end
    end
    grid[t + 1] -= 1
    grid[len - t + 1] -= 1
end

function cutrectangle(hh, ww, recur)
    if isodd(hh)
        h, w = ww, hh
    else
        h, w = hh, ww
    end
    if isodd(h)
        return 0
    elseif w == 1
        return 1
    elseif w == 2
        return h
    elseif h == 2
        return w
    end
    cy = div(h, 2)
    cx = div(w, 2)
    len = (h + 1) * (w + 1)
    grid = zeros(UInt8, len)
    len -= 1
    next = [-1, -w - 1, 1, w + 1]
    if recur
        count[1] = 0
    end
    for x in cx + 1:w - 1
        t = cy * (w + 1) + x
        grid[t + 1] = 1
        grid[len - t + 1] = 1
        walk(cy - 1, x, h, w, grid, len, next)
    end
    count[1] += 1
    if h == w
        count[1] *= 2
    elseif iseven(w) && recur
        cutrectangle(w, h, false)
    end
    return count[1]
end

function runtest()
    for y in 1:10, x in 1:y
        if iseven(x) || iseven(y)
            println("$y x $x: $(cutrectangle(y, x, true))")
        end
    end
end

runtest()
