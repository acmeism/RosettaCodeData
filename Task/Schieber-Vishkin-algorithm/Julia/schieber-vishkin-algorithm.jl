""" rosettacode.org/wiki/Schieber-Vishkin_algorithm """


""" Node structure for a triply linked tree. """
mutable struct Node{T <: Integer}
    child::T
    sib::T
    parent::T
end
Node() = Node{Int}(0, 0, 0)

""" Process the input array `a` of size `n` into a triply linked tree
    and return the vectors pi_, beta, alfa, tau, and lam.
"""
function process(n::Integer, a::Vector)::Tuple
    pi_ = zeros(Int, n + 1) # pi is a builtin constant in Julia
    beta = zeros(Int, n + 1)
    alfa = zeros(Int, n + 1)
    tau = zeros(Int, n + 1)
    lam = zeros(Int, n + 1)
    nodes = [Node() for _ in 1:n+1] # Create n+1 default Node objects

    # Make triply linked tree
    t = 0
    for v in n:-1:1
        u = 0
        while a[v+1] > a[t+1] || (a[v+1] == a[t+1] && v > t)
            u = t
            t = nodes[t+1].parent
        end

        if u != 0
            nodes[v+1].sib = nodes[u+1].sib
            nodes[u+1].sib = 0
            nodes[u+1].parent = v
            nodes[v+1].child = u
        else
            nodes[v+1].sib = nodes[t+1].child
        end

        nodes[t+1].child = v
        nodes[v+1].parent = t
        t = v
    end

    # Begin first traversal
    p = nodes[begin].child
    n_count = 0
    lam[begin] = -1

    """ First traversal function """
    function traversal()
        while true
            # s3: Compute beta in the easy case
            n_count += 1
            pi_[p+1] = n_count
            tau[n_count+1] = 0
            lam[n_count+1] = 1 + lam[(n_count >> 1) + 1]

            if nodes[p+1].child != 0
                p = nodes[p+1].child
                continue # Go back to the beginning of the `while true` loop (s3)
            end

            beta[p+1] = n_count
            break
        end

        # s4: Compute tau, bottom-up
        while true
            tau[beta[p+1]] = nodes[p+1].parent

            if nodes[p+1].sib != 0
                p = nodes[p+1].sib
                return true
            end

            p = nodes[p+1].parent

            # Compute beta in the hard case
            if p != 0
                h = lam[(n_count & (-pi_[p+1])) + 1] # Adjust index for lam access
                beta[p+1] = ((n_count >> h) | 1) << h
            else
                return false # Exit traversal
            end
        end
    end
     # Perform first traversal
    while traversal(); end

    # Begin second traversal
    p = nodes[begin].child
    lam[begin] = lam[n_count+1]
    pi_[begin] = 0
    beta[begin] = 0
    alfa[begin] = 0

    """ Recursive function for second traversal """
    function compute_alfa(node)
        # s7: Compute alfa, top-down
        alfa[node+1] = alfa[nodes[node+1].parent + 1] | (beta[node+1] & (-beta[node+1]))

        if nodes[node+1].child != 0
            compute_alfa(nodes[node+1].child)
        end

        # s8: Continue traversal
        if nodes[node+1].sib != 0
            compute_alfa(nodes[node+1].sib)
        end
    end

    # Perform second (recursive) traversal if needed
    p != 0 && compute_alfa(p)
    return pi_, beta, alfa, tau, lam
end

""" Compute the nearest common ancestor (NCA) of two nodes x and y """
function nca(
    x::Int,
    y::Int,
    beta::Vector{Int},
    alfa::Vector{Int},
    tau::Vector{Int},
    lam::Vector{Int},
    pi_::Vector{Int},
)
    # Find common height
    h = beta[x+1] <= beta[y+1] ? lam[(beta[y+1] & (-beta[x+1] + 1)) + 1] : lam[(beta[x+1] & (-beta[y+1]) + 1) + 1]

    # Find true height
    k = alfa[x+1] & alfa[y+1] & (~(1 << h) + 1) # `~X + 1` is `-X`
    h = lam[(k & (-k)) + 1]

    # Find beta[z]
    j = ((beta[x+1] >> h) | 1) << h

    # Find x' and y'
    if j != beta[x+1]
        l = lam[(alfa[x+1] & ((1 << h) - 1)) + 1]
        x = tau[(((beta[x+1] >> l) | 1) << l) + 1]
    end

    if j != beta[y+1]
        l = lam[(alfa[y+1] & ((1 << h) - 1)) + 1]
        y = tau[(((beta[y+1] >> l) | 1) << l) + 1]
    end

    # Find z
    return pi_[x+1] <= pi_[y+1] ? x : y
end

""" Solve a test case using Schieber-Vishkin given values and queries,
    running the queries in parallel using threads.
"""
function schiebervishkin(
	n::Int,
	values::Vector{Int32},
	queries::Vector{Tuple{Int, Int}},
)
	results = zeros(Int32, length(queries))

	a = Int[typemax(Int32)]
	r = zeros(Int, n + 2)
	b = zeros(Int, n + 2)

	big_n = 1
	count = 0
	oldx = nothing

	for i in 1:n
		x = values[i]

		if i > 1 && x != oldx
			push!(a, count)
			r[big_n+1] = i
			big_n += 1
			count = 0
		end

		b[i] = big_n
		count += 1
		oldx = x # Store the value directly
	end

	push!(a, count)
	r[big_n+1] = n + 1

	(pi_, beta, alfa, tau, lam) = process(big_n, a)

	Threads.@threads for t in eachindex(queries)
		i, j = queries[t]
		x, y = b[i], b[j]

		z = 0
		if x == y
			z = (j - i + 1)
		else
			if x + 1 != y
				z = a[nca(x + 1, y - 1, beta, alfa, tau, lam, pi_) + 1]
			end
			z = max(z, r[x+1] - i, a[y+1] - (r[y+1] - j - 1))
		end
		results[t] = z
	end

	return results
end

function main()
    # Hard-coded test data
    test_cases = [
        (
            10, # n
            Int32[-1, -1, 1, 1, 1, 1, 3, 10, 10, 10], # values (Int32)
            [(2, 3), (1, 10), (5, 10)], # queries (Tuple of Int)
            Int32[1, 4, 3] # expected (Int32)
        )
    ]

    for (idx, (n, values, queries, expected)) in enumerate(test_cases)
        println("Test Case $(idx):")
        println("Size: $(n), Queries: $(length(queries))")
        println("Values: ", join(map(string, values), " "))

        results = schiebervishkin(n, values, queries)

        println("Queries and Results:")
        for q_idx in eachindex(queries)
            i, j = queries[q_idx]
            result = results[q_idx]
            exp = expected[q_idx]

            println("Query: $(i) $(j)")
            println("Result: $(result) (Expected: $(exp))")
            if result != exp
                println("  WARNING: Result doesn't match expected output")
            end
        end

        println()
    end
end

main()
