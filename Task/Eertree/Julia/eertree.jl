mutable struct Node
    edges::Dict{Char, Node}
    link::Union{Node, Missing}
    sz::Int
    Node() = new(Dict(), missing, 0)
end

sizednode(x) = (n = Node(); n.sz = x; n)

function eertree(str)
    nodes = Vector{Node}()
    oddroot = sizednode(-1)
    evenroot = sizednode(0)
    oddroot.link = evenroot
    evenroot.link = oddroot
    S = "0"
    maxsuffix = evenroot

    function maxsuffixpal(startnode,a::Char)
        # Traverse the suffix-palindromes of tree looking for equality with a
        u = startnode
        i = length(S)
        k = u.sz
        while u !== oddroot && S[i - k] != a
            if u === u.link
                throw("circular reference above oddroot")
            end
            u = u.link
            k = u.sz
        end
        u
    end

    function addchar(a::Char)
        Q = maxsuffixpal(maxsuffix, a)
        creatednode = !haskey(Q.edges, a)
        if creatednode
            P = sizednode(Q.sz + 2)
            push!(nodes, P)
            if P.sz == 1
                P.link = evenroot
            else
                P.link = maxsuffixpal(Q.link, a).edges[a]
            end
            Q.edges[a] = P            # adds edge (Q, P)
        end
        maxsuffix = Q.edges[a]        # P becomes the new maxsuffix
        S *= string(a)
        creatednode
    end

    function getsubpalindromes()
        result = Vector{String}()
        getsubpalindromes(oddroot, [oddroot], "", result)
        getsubpalindromes(evenroot, [evenroot], "", result)
        result
    end

    function getsubpalindromes(nd, nodestohere, charstohere, result)
        for (lnkname, nd2) in nd.edges
            getsubpalindromes(nd2, vcat(nodestohere, nd2), charstohere * lnkname, result)
        end
        if nd !== oddroot && nd !== evenroot
            assembled = reverse(charstohere) *
                (nodestohere[1] === evenroot ? charstohere : charstohere[2:end])
            push!(result, assembled)
        end
    end

    println("Results of processing string \"$str\":")
    for c in str
        addchar(c)
    end
    println("Number of sub-palindromes: ", length(nodes))
    println("Sub-palindromes: ", getsubpalindromes())
end

eertree("eertree")
