using DataStructures # for Deque

struct BlossomMatching
	nv::Int # number of vertices
	matches::Vector{Int}
	parents::Vector{Int}
	base_vertices::Vector{Int}
	used::Vector{Bool}
	blossom::Vector{Bool}
end

"""Find least common ancestor of a and b in the forest of alternating tree."""
function lca(m::BlossomMatching, a, b)
	used_path = falses(m.nv)
	while true
		a = m.base_vertices[a]
		used_path[a] = true
		m.matches[a] == 0 && break
		a = m.parents[m.matches[a]]
	end
	while true
		b = m.base_vertices[b]
		used_path[b] && return b
		b = m.parents[m.matches[b]]
	end
end

"""Mark vertices along the path from v to base b, setting their parent to x."""
function mark_path!(m::BlossomMatching, v, b, x)
	while m.base_vertices[v] != b
		m.blossom[m.base_vertices[v]] = true
		m.blossom[m.base_vertices[m.matches[v]]] = true
		m.parents[v] = x
		x = m.matches[v]
		v = m.parents[x]
	end
end

"""Try to find an augmenting path starting from root."""
function find_path!(m::BlossomMatching, adj, root)
	# reset struct
	m.used .= false
	m.parents .= 0
	m.base_vertices .= collect(1:m.nv)
	q = Deque{Int}()
	m.used[root] = true
	push!(q, root)
	while !isempty(q)
		v = popfirst!(q)
		for u in adj[v]
			# two cases to skip
			if m.base_vertices[v] == m.base_vertices[u] || m.matches[v] == u
				continue
			end
			# found a blossom or an odd cycle edge
			if u == root || m.matches[u] != 0 && m.parents[m.matches[u]] != 0
				curbase = lca(m, v, u)
				m.blossom .= false
				mark_path!(m, v, curbase, u)
				mark_path!(m, u, curbase, v)
				# contract blossom
				for i in 1:m.nv
					if m.blossom[m.base_vertices[i]]
						m.base_vertices[i] = curbase
						if !m.used[i]
							m.used[i] = true
							push!(q, i)
						end
					end
				end
				# otherwise extend the alternating tree
			elseif m.parents[u] == 0
				m.parents[u] = v
				if m.matches[u] == 0
					# augmenting path found: flip matches along the path
					curr = u
					while curr != 0
						prev = m.parents[curr]
						nxt = prev != 0 ? m.matches[prev] : 0
						m.matches[curr] = prev
						m.matches[prev] = curr
						curr = nxt
					end
					return true
				end
				# else continue BFS from the matches partner
				m.used[m.matches[u]] = true
				push!(q, m.matches[u])
			end
		end
	end
	return false
end

"""
	Finds maximum matching in a general undirected graph using Edmonds' Blossom algorithm.
	Input: adj — list of lists, adj[u] is the list of neighbors of u (1-indexed).
	Returns: match, size
	  match — list where match[u] = v if u–v is in the matching, or 0
	  size  — number of matches edges
"""
function max_matching(n, adj)
	n <= 0 && return Int[], 0 # since the graph has no edges
	m = BlossomMatching(n, zeros(Int, n), zeros(Int, n), zeros(Int, n), falses(n), falses(n))
	#  grow matching by finding augmenting paths
	match_count = count(v -> m.matches[v] == 0 && find_path!(m, adj, v), 1:n)
	return m.matches, match_count
end

function test_blossom()
	# Example: 5‑cycle (odd cycle)
	# Vertices: 0–1–2–3–4–0
	nv = 5
	edges = [(0, 1), (1, 2), (2, 3), (3, 4), (4, 0)]
	adj = [Int[] for _ in 1:nv]
	for (u, v) in edges
		push!(adj[u + 1], v + 1) # convert zero based to one based input
	end
	matches, msize = max_matching(nv, adj)
	println("Maximum matching size: $msize")
	println("Matched pairs:")
	seen = Set{Tuple{Int, Int}}()
	for (u, v) in enumerate(matches)
		if v != 0 && (v, u) ∉ seen
			println("  $(u - 1) – $(v - 1)")  # 1 based to 0 based output
			push!(seen, (u, v))
		end
	end
end

test_blossom()
