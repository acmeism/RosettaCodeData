abstract type HuffmanTree end

struct HuffmanLeaf <: HuffmanTree
    ch::Char
    freq::Int
end

struct HuffmanNode <: HuffmanTree
    freq::Int
    left::HuffmanTree
    right::HuffmanTree
end

function makefreqdict(s::String)
    d = Dict{Char, Int}()
    for c in s
        if !haskey(d, c)
            d[c] = 1
        else
            d[c] += 1
        end
    end
    d
end

function huffmantree(ftable::Dict)
    trees::Vector{HuffmanTree} = [HuffmanLeaf(ch, fq) for (ch, fq) in ftable]
    while length(trees) > 1
        sort!(trees, lt = (x, y) -> x.freq < y.freq, rev = true)
        least = pop!(trees)
        nextleast = pop!(trees)
        push!(trees, HuffmanNode(least.freq + nextleast.freq, least, nextleast))
    end
    trees[1]
end

printencoding(lf::HuffmanLeaf, code) = println(lf.ch == ' ' ? "space" : lf.ch, "\t", lf.freq, "\t", code)

function printencoding(nd::HuffmanNode, code)
    code *= '0'
    printencoding(nd.left, code)
    code = code[1:end-1]

    code *= '1'
    printencoding(nd.right, code)
    code = code[1:end-1]
end

const msg = "this is an example for huffman encoding"

println("Char\tFreq\tHuffman code")

printencoding(huffmantree(makefreqdict(msg)), "")
