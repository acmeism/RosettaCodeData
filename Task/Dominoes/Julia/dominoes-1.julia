const tableau = [
    0 5 1 3 2 2 3 1;
    0 5 5 0 5 2 4 6;
    4 3 0 3 6 6 2 0;
    0 6 2 3 5 1 2 6;
    1 1 3 0 0 2 4 5;
    2 1 4 3 3 4 6 6;
    6 4 5 1 5 4 1 4
]

const dominoes = [(i, j) for i in 0:size(tableau)[1]-1, j in 0:size(tableau)[2]-1 if i <= j]
sorted(dom) = first(dom) > last(dom) ? reverse(dom) : dom

"""
`patterns` contains solution(s), each containing a partially completed grid, the
dominos used, and steps taken to get to that point in the grid. Proceed via iterating
through possible tile placements from upper left to lower right, adding horizontal and
vertical tile placements, dropping those that require more than one of the same domino.
Consolidate in `patterns`` the newly lengthened layouts each step as moves are added.
"""
function findlayouts(tab = tableau, doms = dominoes)
    nrows, ncols = size(tab)
    patterns = [(zero(tab) .- 1, Tuple{Int, Int}[], Int[])]
    while true
        newpat = empty(patterns)
        for (ut, ud, up) in patterns
            pos = findfirst(x -> x == -1, ut)
            pos == nothing && continue
            row, col = Tuple(pos)
            if row < nrows && ut[row + 1, col] == -1 &&
               !(sorted((tab[row, col], tab[row + 1, col])) in ud)
                newut = copy(ut)
                newut[row:row+1, col] .= tab[row:row+1, col]
                push!(newpat, (newut, [ud; sorted((tab[row, col], tab[row + 1, col]))],
                   [up; [row, col, row + 1, col]]))
            end
            if col < ncols && ut[row, col + 1] == -1 &&
               !(sorted((tab[row, col], tab[row, col + 1])) in ud)
                newut = copy(ut)
                newut[row, col:col+1] .= tab[row, col:col+1]
                push!(newpat, (newut, [ud; sorted((tab[row, col], tab[row, col + 1]))],
                   [up; [row, col, row, col + 1]]))
            end
        end
        isempty(newpat) && break
        patterns = newpat
        length(last(first(patterns))) == length(doms) && break
    end
    return patterns
end

function printlayout(pattern)
    tab, dom, pos = pattern
    bytes = [[UInt8(' ') for _ in 1:(size(tab)[2] * 2 - 1)] for _ in 1:size(tab)[1]*2]
    for idx in 1:4:length(pos)-1
        x1, y1, x2, y2 = pos[idx:idx+3]
        n1, n2 = tab[x1, y1], tab[x2, y2]
        bytes[x1 * 2 - 1][y1 * 2 - 1] = Char(n1 + '0')
        bytes[x2 * 2 - 1][y2 * 2 - 1] = Char(n2 + '0')
        if x1 == x2 # horizontal
            bytes[x1 * 2 - 1][y1 * 2] = Char('+')
        elseif y1 == y2 # vertical
            bytes[x1 * 2][y1 * 2 - 1] = Char('+')
        end
    end
    println(join(String.(bytes), "\n"))
end


for pat in findlayouts()
    printlayout(pat)
end
@time findlayouts()

const t2 = [
    6 4 2 2 0 6 5 0;
    1 6 2 3 4 1 4 3;
    2 1 0 2 3 5 5 1;
    1 3 5 0 5 6 1 0;
    4 2 6 0 4 0 1 1;
    4 4 2 0 5 3 6 3;
    6 6 5 2 5 3 3 4
]
@time lays = findlayouts(t2, dominoes)
printlayout(first(lays))
println(length(lays), " layouts found.")
