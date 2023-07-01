const oo = typemax(Int)

"""The suffix-tree's node."""
mutable struct Node
    children::Dict{Char, Int}
    start::Int
    ending::Int
    suffixlink::Int
    suffixindex::Int
end

Node() = Node(Dict(), 0, oo, 0, -1)
Node(start, ending) = Node(Dict(), start, ending, 0, -1)

""" Ukkonen Suffix-Tree """
mutable struct SuffixTree
    nodes::Vector{Node}
    text::Vector{Char}
    root::Int
    position::Int
    currentnode::Int
    needsuffixlink::Int
    remainder::Int
    activenode::Int
    activelength::Int
    activeedge::Int
end

edgelength(st, n::Node) = min(n.ending, st.position + 1) - n.start

function newnode(st, start, ending)
    st.currentnode += 1
    st.nodes[st.currentnode] = Node(start, ending)
    return st.currentnode
end

function SuffixTree(str::String)
    nodes = [Node() for _ in 1:length(str) * 2]
    st = SuffixTree(nodes, [c for c in str], 1, 0, 0, 0, 0, 1, 1, 1)
    st.root = newnode(st, 0, 0)
    st.activenode = st.root
    for i in 1:length(st.text)
        extendsuffixtree(st, i)
    end
    setsuffixindexbyDFS(st, st.nodes[st.root], 0)
    return st
end

function addsuffixlink(st, nodenum::Int)
    if st.needsuffixlink > 0
        st.nodes[st.needsuffixlink].suffixlink = nodenum
    end
    st.needsuffixlink = nodenum
end

activeedge(st) = st.text[st.activeedge]

function walkdown!(st, currnode::Int)
    len = edgelength(st, st.nodes[currnode])
    st.activelength < len && return false
    st.activeedge += len
    st.activelength -= len
    st.activenode = currnode
    return true
end

function extendsuffixtree(st, pos)
    st.position = pos
    st.needsuffixlink = 0
    st.remainder += 1
    while st.remainder > 0
        st.activelength == 0 && (st.activeedge = st.position)
        if !haskey(st.nodes[st.activenode].children, activeedge(st))
            nodenum = newnode(st, st.position, oo)
            st.nodes[st.activenode].children[activeedge(st)] = nodenum
            addsuffixlink(st, st.activenode)
        else
            next = st.nodes[st.activenode].children[activeedge(st)]
            walkdown!(st, next) && continue
            if st.text[st.nodes[next].start + st.activelength] == st.text[pos]
                addsuffixlink(st, st.activenode)
                st.activelength += 1
                break
            end
            splt = newnode(st, st.nodes[next].start, st.nodes[next].start + st.activelength)
            st.nodes[st.activenode].children[activeedge(st)] = splt
            nodenum = newnode(st, st.position, oo)
            st.nodes[splt].children[st.text[pos]] = nodenum
            st.nodes[next].start += st.activelength
            st.nodes[splt].children[st.text[st.nodes[next].start]] = next
            addsuffixlink(st, splt)
        end
        st.remainder -= 1
        if st.activenode == st.root && st.activelength > 0
            st.activelength -= 1
            st.activeedge = st.position - st.remainder + 1
        elseif st.activenode != st.root
            st.activenode = st.nodes[st.activenode].suffixlink
        end
    end
end

function setsuffixindexbyDFS(st, node, labelheight, verbose=false)
    verbose && node.start > 0 && print(st.text[node.start:min(node.ending, length(st.text))])
    isleaf = true
    for child in map(v -> st.nodes[v], collect(values(node.children)))
        verbose && isleaf && node.start > 0 && println(" [", node.suffixindex, "]")
        isleaf = false
        setsuffixindexbyDFS(st, child, labelheight + edgelength(st, child))
    end
    if isleaf
        idx = length(st.text) - labelheight
        node.suffixindex = idx
        verbose && println(" [$idx]")
    end
end

function dotraversal(st)
    maxheight, substringstartindices = 0, [0]
    function traversal(node::Node, labelheight)
        if node.suffixindex == -1
            for child in map(v -> st.nodes[v], collect(values(node.children)))
                traversal(child, labelheight + edgelength(st, child))
            end
        elseif maxheight < labelheight - edgelength(st, node)
            maxheight = labelheight - edgelength(st, node)
            substringstartindices = [node.suffixindex + 1]
        elseif maxheight == labelheight - edgelength(st, node)
            push!(substringstartindices, node.suffixindex + 1)
        end
    end
    traversal(st.nodes[st.root], 0)
    return maxheight, substringstartindices
end

function getlongestrepeatedsubstring(st::SuffixTree, label="", printresult=true)
    len, starts = dotraversal(st)
    substring = len == 0 ? "" :
        join(unique(map(x -> String(st.text[x:x+len-1]), starts)), " (or) ")
    if printresult
        print("  ", label == "" ? String(st.text) : label, ": ")
        println(len == 0 ? "No repeated substring." : substring)
    end
    return substring
end

function testsuffixtree()
    tests = [
        "CAAAABAAAABD\$",
        "GEEKSFORGEEKS\$",
        "AAAAAAAAAA\$",
        "ABCDEFG\$",
        "ABABABA\$",
        "ATCGATCGA\$",
        "banana\$",
        "abcpqrabpqpq\$",
        "pqrpqpqabab\$",
    ]
    println("Longest Repeated Substring in:\n")
    for test in tests
        st = SuffixTree(test)
        getlongestrepeatedsubstring(st)
    end
    println()
    sπ = ""
    setprecision(4000000) do
        sπ = string(BigFloat(π))[3:end]
    end
    for number in [1000, 10000, 100000, 1000000]
        text = sπ[1:number] * "\$"
        @time begin
            st = SuffixTree(text)
            getlongestrepeatedsubstring(st, "first $number d.p. of π")
        end
    end
end

testsuffixtree()
