longest(a::String, b::String) = length(a) ≥ length(b) ? a : b

"""
julia> lcsrecursive("thisisatest", "testing123testing")
"tsitest"
"""
# Recursive
function lcsrecursive(xstr::String, ystr::String)
    if length(xstr) == 0 || length(ystr) == 0
        return ""
    end

    x, xs, y, ys = xstr[1], xstr[2:end], ystr[1], ystr[2:end]
    if x == y
        return string(x, lcsrecursive(xs, ys))
    else
        return longest(lcsrecursive(xstr, ys), lcsrecursive(xs, ystr))
    end
end

# Dynamic
function lcsdynamic(a::String, b::String)
    lengths = zeros(Int, length(a) + 1, length(b) + 1)

    # row 0 and column 0 are initialized to 0 already
    for (i, x) in enumerate(a), (j, y) in enumerate(b)
        if x == y
            lengths[i+1, j+1] = lengths[i, j] + 1
        else
            lengths[i+1, j+1] = max(lengths[i+1, j], lengths[i, j+1])
        end
    end

    # read the substring out from the matrix
    result = ""
    x, y = length(a) + 1, length(b) + 1
    while x > 1 && y > 1
        if lengths[x, y] == lengths[x-1, y]
            x -= 1
        elseif lengths[x, y] == lengths[x, y-1]
            y -= 1
        else
            @assert a[x-1] == b[y-1]
            result = string(a[x-1], result)
            x -= 1
            y -= 1
        end
    end

    return result
end


@show lcsrecursive("thisisatest", "testing123testing")
@time lcsrecursive("thisisatest", "testing123testing")
@show lcsdynamic("thisisatest", "testing123testing")
@time lcsdynamic("thisisatest", "testing123testing")
