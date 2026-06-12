const VALID_CHARS = collect('a':'z')

mutable struct Node
    son::Vector{Int}
    ans::Int
    fail::Int
    du::Int
    idx::Int
end
Node() = Node(zeros(Int, length(VALID_CHARS)), 0, 1, 0, 0)

mutable struct ACAutomaton
    tr::Vector{Node}
    tot::Int
    final_ans::Vector{Int}
    pidx::Int
end
ACAutomaton(max_nodes) = ACAutomaton([Node() for _ in 1:max_nodes], 1, Int[], 0)

function insert(ac::ACAutomaton, pattern)
    u = 1 # 1-based, so root node position is 1
    for ch in pattern
        char_code = findfirst(==(ch), VALID_CHARS)
        isnothing(char_code) && continue
        if ac.tr[u].son[char_code] == 0
            ac.tot += 1
            ac.tr[u].son[char_code] = ac.tot
        end
        u = ac.tr[u].son[char_code]
    end
    if ac.tr[u].idx == 0
        ac.pidx += 1
        ac.tr[u].idx = ac.pidx
    end
    return ac.tr[u].idx
end

function build(ac::ACAutomaton)
    q = [ac.tr[begin].son[i] for i in eachindex(VALID_CHARS) if ac.tr[begin].son[i] != 0]
    while !isempty(q)
        u = q[begin]
        q = q[begin+1:end]
        for i in eachindex(VALID_CHARS)
            son_node_idx = ac.tr[u].son[i]
            fail_node_idx = ac.tr[u].fail
            if son_node_idx != 0
                ac.tr[son_node_idx].fail = ac.tr[fail_node_idx].son[i]
                ac.tr[ac.tr[son_node_idx].fail].du += 1
                push!(q, son_node_idx)
            else
                ac.tr[u].son[i] = ac.tr[fail_node_idx].son[i]
            end
        end
    end
end

function query(ac::ACAutomaton, text)
    u = 1
    for ch in text
        char_code = findfirst(==(ch), VALID_CHARS)
        isnothing(char_code) && continue
        u = ac.tr[u].son[char_code]
        ac.tr[u].ans += 1
    end
end

function calculate_final_answers(ac::ACAutomaton)
    ac.final_ans = zeros(Int, ac.pidx + 1)
    q = filter(i -> ac.tr[i].du == 0, 1:ac.tot)
    while !isempty(q)
        u = pop!(q)
        idx = ac.tr[u].idx
        if idx != 0
            ac.final_ans[idx] = ac.tr[u].ans
        end

        v = ac.tr[u].fail
        if v > 1
            ac.tr[v].ans += ac.tr[u].ans
            ac.tr[v].du -= 1
            ac.tr[v].du == 0 && push!(q, v)
        end
    end
end

function test_aho_corasick()
    max_nodes, n = 200000 + 6, 5
    ac = ACAutomaton(max_nodes)
    ids = zeros(Int, n + 1)
    input = ["a", "bb", "aa", "abaa", "abaaa"]
    text = "abaaabaa"
    for i in 1:n
        pattern = input[i]
        ids[i+1] = insert(ac, pattern)
    end
    build(ac)
    query(ac, text)
    calculate_final_answers(ac)
    for i in 1:n
        uniqueid = ids[i]
        println("Number of instances of $(input[i]): ", ac.final_ans[uniqueid+1])
    end
end

test_aho_corasick()
