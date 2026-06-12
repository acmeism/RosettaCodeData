import Base.print

mutable struct Node
    sub::String
    ch::Vector{Int}
    Node(str, v=Int[]) = new(str, v)
end

struct SuffixTree
    nodes::Vector{Node}
    function SuffixTree(s::String)
        nod = [Node("", Int[])]
        for i in 1:length(s)
            addSuffix!(nod, s[i:end])
        end
        return new(nod)
    end
end

function addSuffix!(tree::Vector{Node}, suf::String)
    n, i = 1, 1
    while i <= length(suf)
        x2, n2, b = 1, 1, suf[i]
        while true
            children = tree[n].ch
            if x2 > length(children)
                push!(tree, Node(suf[i:end]))
                push!(tree[n].ch, length(tree))
                return
            end
            n2 = children[x2]
            (tree[n2].sub[1] == b) && break
            x2 += 1
        end
        sub2, j = tree[n2].sub, 0
        while j < length(sub2)
            if suf[i + j] != sub2[j + 1]
                push!(tree, Node(sub2[1:j], [n2]))
                tree[n2].sub = sub2[j+1:end]
                n2 = length(tree)
                tree[n].ch[x2] = n2
                break
            end
            j += 1
        end
        i += j
        n = n2
    end
end

function Base.print(io::IO, suffixtree::SuffixTree)
    function treeprint(n::Int, pre::String)
        children = suffixtree.nodes[n].ch
        if isempty(children)
            println("╴ ", suffixtree.nodes[n].sub)
        else
            println("┐ ", suffixtree.nodes[n].sub)
            for c in children[1:end-1]
                print(pre, "├─")
                treeprint(c, pre * "│ ")
            end
            print(pre, "└─")
            treeprint(children[end], pre * "  ")
        end
    end
    if isempty(suffixtree.nodes)
        println("<empty>")
    else
        treeprint(1, "")
    end
end

println(SuffixTree("banana\$"))
