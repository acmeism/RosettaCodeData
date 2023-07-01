using Base.Iterators

struct NonogramPuzzle
    nrows::Int
    ncols::Int
    xhints::Vector{Vector{Int}}
    yhints::Vector{Vector{Int}}
    solutions:: Vector{Any}
    NonogramPuzzle(xh, yh) = new(length(xh), length(yh), xh, yh, Vector{NTuple{4,Array{Int64,1}}}())
end

ycols2xrows(ycols) = [[ycols[i][j] for i in eachindex(ycols)] for j in eachindex(ycols[1])]

function hintsfromcol(rowvec, col, nrows)
    hints = Vector{Int}()
    hintrun = 0
    for row in rowvec
        if row[col] != 0
            hintrun += 1
            if col == nrows
                push!(hints, hintrun)
            end
        elseif hintrun > 0
            push!(hints, hintrun)
            hintrun = 0
        end
    end
    hints
end

function nonoblocks(hints, len)
    minsized(arr) = vcat(map(x -> vcat(fill(1, x), [0]), arr)...)[1:end-1]
    minlen(arr) = sum(arr) + length(arr) - 1
    if isempty(hints)
        return fill(0, len)
    elseif minlen(hints) == len
        return minsized(hints)
    end
    possibilities = Vector{Vector{Int}}()
    allbuthead = hints[2:end]
    for leftspace in 0:(len - minlen(hints))
        header = vcat(fill(0, leftspace), fill(1, hints[1]), [0])
        rightspace = len - length(header)
        if isempty(allbuthead)
            push!(possibilities, rightspace <= 0 ? header[1:len] : vcat(header, fill(0, rightspace)))
        elseif minlen(allbuthead) == rightspace
            push!(possibilities, vcat(header, minsized(allbuthead)))
        else
            foreach(x -> push!(possibilities, vcat(header, x)), nonoblocks(allbuthead, rightspace))
        end
    end
    possibilities
end

function exclude!(xchoices, ychoices)
    andvec(a) = findall(x -> x == 1, foldl((x, y) -> [x[i] & y[i] for i in 1:length(x)], a))
    orvec(a)  = findall(x -> x == 0, foldl((x, y) -> [x[i] | y[i] for i in 1:length(x)], a))
    filterbyval!(arr, val, pos) =  if !isempty(arr) filter!(x -> x[pos] == val, arr); end
    ensurevecvec(arr::Vector{Vector{Int}}) = arr
    ensurevecvec(arr::Vector{Int}) = [arr]
    function excl!(choices, otherchoices)
        for i in 1:length(choices)
            if length(choices[i]) > 0
                all1 = andvec(choices[i])
                all0 = orvec(choices[i])
                foreach(n -> filterbyval!(otherchoices[n], 1, i), all1)
                foreach(n -> filterbyval!(otherchoices[n], 0, i), all0)
            end
        end
    end
    xclude!(x, y) = (excl!(x, y); x = map(ensurevecvec, x); y = map(ensurevecvec, y); (x, y))
    xlen, ylen = sum(map(length, xchoices)), sum(map(length, ychoices))
    while true
        ychoices, xchoices = xclude!(ychoices, xchoices)
        if any(isempty, xchoices)
            return
        end
        xchoices, ychoices = xclude!(xchoices, ychoices)
        if any(isempty, ychoices)
            return
        end
        newxlen, newylen = sum(map(length, xchoices)), sum(map(length, ychoices))
        if newxlen == xlen && newylen == ylen
            return
        end
        xlen, ylen = newxlen, newylen
    end
end

function trygrids(nonogram)
    xchoices = [nonoblocks(nonogram.xhints[i], nonogram.ncols) for i in 1:nonogram.nrows]
    ychoices = [nonoblocks(nonogram.yhints[i], nonogram.nrows) for i in 1:nonogram.ncols]
    exclude!(xchoices, ychoices)
    if all(x -> length(x) == 1, xchoices)
        println("Unique solution.")
        push!(nonogram.solutions, [x[1] for x in xchoices])
    elseif all(x -> length(x) == 1, ychoices)
        println("Unique solution.")
        ycols = [y[1] for y in ychoices]
        push!(nonogram.solutions, ycols2xrows(ycols))
    else
        println("Brute force: $(prod(map(length, xchoices))) possibilities.")
        for stack in product(xchoices...)
            arr::Vector{Vector{Int}} = [i isa Vector ? i : [i] for i in stack]
            if all(x -> length(x) == nonogram.ncols, arr) &&
               all(y -> hintsfromcol(arr, y, nonogram.nrows) == nonogram.yhints[y], 1:nonogram.ncols)
                push!(nonogram.solutions, arr)
            end
        end
        nsoln = length(nonogram.solutions)
        println(nsoln == 0 ? "No" : nsoln, " solutions.")
    end
end

# The first puzzle below requires brute force, and the second has no solutions.
const testnonograms = """
B B A A
B B A A

B A A
A A A

C BA CB BB F AE F A B
AB CA AE GA E C D C

F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC
D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA

CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC
BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF AAAAD BDG CEF CBDB BBB FC

E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G
E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM
"""

function processtestpuzzles(txt)
    solutiontxt(a) = (s = ""; for r in a for c in r; s *= (c == 0 ? "." : "#") end; s *= "\n" end; s)
    txtline2ints(s) = [[UInt8(ch - 'A' + 1) for ch in r] for r in split(s, r"\s+")]
    linepairs = uppercase.(string.(split(txt, "\n\n")))
    pcount = 0
    for xyhints in linepairs
        xh, yh = map(x -> txtline2ints(strip(x)), split(xyhints, "\n"))
        nonogram = NonogramPuzzle(xh, yh)
        println("\nPuzzle $(pcount += 1):")
        trygrids(nonogram)
        foreach(x -> println(solutiontxt(x), "\n"), nonogram.solutions)
    end
end

processtestpuzzles(testnonograms)
