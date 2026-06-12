""" Module for the graphics Wave Function Collapse algorithm """
module WFC

export wfc, xy, xyz

using Random

"""helper indexing for a vector treated as a pseudo matrix """
function xy(row::Int, col::Int, width::Int)::Int
    col + row * width
end

""" helper indexing function for a vector treated as a pseudo 3 to 4D array """
function xyz(page::Int, row::Int, col::Int, height::Int, width::Int)::Int
    xy(xy(page, row, height), col, width)
end

""" The Wave Function Collapse algorithm for graphic tile generation """
function wfc(blocks::Vector{UInt8}, bdim::Tuple{Int, Int, Int}, tdim::Tuple{Int, Int})::Vector{UInt8}
    td0, td1 = tdim
    n = td0 * td1
    adj = zeros(Int, n * 4)  # Indices in R of the four adjacent blocks.

    for i in 0:(td0-1)
        for j in 0:(td1-1)
            adj[xyz(i, j, 0, td1, 4)+1] = xy(mod(i - 1, td0), mod(j, td1), td1)
            adj[xyz(i, j, 1, td1, 4)+1] = xy(mod(i, td0), mod(j - 1, td1), td1)
            adj[xyz(i, j, 2, td1, 4)+1] = xy(mod(i, td0), mod(j + 1, td1), td1)
            adj[xyz(i, j, 3, td1, 4)+1] = xy(mod(i + 1, td0), mod(j, td1), td1)
        end
    end

    bd0, bd1, bd2 = bdim

    horz = ones(UInt8, bd0 * bd0)
    for i in 0:(bd0-1)
        for j in 0:(bd0-1)
            horz[xy(i, j, bd0)+1] = 1
            for k in 0:(bd1-1)
                if blocks[xyz(i, k, 0, bd1, bd2)+1] != blocks[xyz(j, k, bd2-1, bd1, bd2)+1]
                    horz[xy(i, j, bd0)+1] = 0
                end
            end
        end
    end

    vert = ones(UInt8, bd0 * bd0)
    for i in 0:(bd0-1)
        for j in 0:(bd0-1)
            vert[xy(i, j, bd0)+1] = 1
            for k in 0:(bd2-1)
                if blocks[xyz(i, 0, k, bd1, bd2)+1] != blocks[xyz(j, bd1-1, k, bd1, bd2)+1]
                    vert[xy(i, j, bd0)+1] = 0
                    break
                end
            end
        end
    end

    allow = ones(UInt8, 4 * (bd0 + 1) * bd0)
    for i in 0:(bd0-1)
        for j in 0:(bd0-1)
            allow[xyz(0, i, j, bd0+1, bd0)+1] = vert[xy(j, i, bd0)+1]
            allow[xyz(1, i, j, bd0+1, bd0)+1] = horz[xy(j, i, bd0)+1]
            allow[xyz(2, i, j, bd0+1, bd0)+1] = horz[xy(i, j, bd0)+1]
            allow[xyz(3, i, j, bd0+1, bd0)+1] = vert[xy(i, j, bd0)+1]
        end
    end

    todo = zeros(Int, n)
    wave = zeros(UInt8, n * bd0)
    entropy = zeros(Int, n)
    indices = zeros(Int, n)
    possible = zeros(Int, bd0)
    r = fill(bd0, n)

    while true
        c = 0
        for i in 0:(n-1)
            if bd0 == r[i+1]
                todo[c+1] = i
                c += 1
            end
        end
        if c == 0
            break
        end
        min_entropy = bd0
        for i in 0:(c-1)
            entropy[i+1] = 0
            for j in 0:(bd0-1)
                val =
                    allow[xyz(0, r[adj[xy(todo[i+1], 0, 4)+1]+1], j, bd0+1, bd0)+1] &
                    allow[xyz(1, r[adj[xy(todo[i+1], 1, 4)+1]+1], j, bd0+1, bd0)+1] &
                    allow[xyz(2, r[adj[xy(todo[i+1], 2, 4)+1]+1], j, bd0+1, bd0)+1] &
                    allow[xyz(3, r[adj[xy(todo[i+1], 3, 4)+1]+1], j, bd0+1, bd0)+1]
                wave[xy(i, j, bd0)+1] = val
                entropy[i+1] += val
            end
            if entropy[i+1] < min_entropy
                min_entropy = entropy[i+1]
            end
        end
        if min_entropy == 0
            return UInt8[]
        end
        d = 0
        for i in 0:(c-1)
            if min_entropy == entropy[i+1]
                indices[d+1] = i
                d += 1
            end
        end
        ndx = indices[rand(1:d)]
        ind = ndx * bd0
        d = 0
        for i in 0:(bd0-1)
            if wave[ind+i+1] != 0
                possible[d+1] = i
                d += 1
            end
        end
        r[todo[ndx+1]+1] = possible[rand(1:d)]
    end

    isempty(r) && return UInt8[]
    result = zeros(UInt8, (1 + td0 * (bd1 - 1)) * (1 + td1 * (bd2 - 1)))
    for i0 in 0:(td0-1)
        for i1 in 0:(bd1-1)
            for j0 in 0:(td1-1)
                for j1 in 0:(bd2-1)
                    result[xy(xy(j0, j1, bd2-1), xy(i0, i1, bd1-1), 1+td1*(bd2-1))+1] =
                        blocks[xyz(r[xy(i0, j0, td1)+1], i1, j1, bd1, bd2)+1]
                end
            end
        end
    end
    return result
end

end # module

using .WFC: wfc, xy

const BLOCKS = UInt8[
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    1, 1, 1,
    0, 1, 0,
    0, 1, 0,
    0, 1, 1,
    0, 1, 0,
    0, 1, 0,
    1, 1, 1,
    0, 0, 0,
    0, 1, 0,
    1, 1, 0,
    0, 1, 0,
]

const BDIMS = (5, 3, 3)
const SIZE = (8, 8)

""" test the algorithm """
function testwfc(blocks = BLOCKS, bdims = BDIMS, siz = SIZE)
    tile = wfc(blocks, bdims, siz)
    if isempty(tile)
        return
    end
    for i in 0:16
        for j in 0:16
            print(" #"[tile[xy(i, j, 17)+1]+1], " ")
        end
        println()
    end
end

testwfc()
