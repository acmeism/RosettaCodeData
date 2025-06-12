def shortest_paths (edges edgelist, start)
  # put the edges in a hash for easier access
  edges = Hash(Symbol, Array({Symbol, Int32})).new {|h, k| h[k] = [] of {Symbol, Int32} }
  edgelist.each do |from, to, cost|
    edges[from] << { to, cost }
  end
  vertices = { start => { cost: 0, prev: :"" } }
  queue = Deque.new [start]
  while queue.present?
    node = queue.shift
    current_cost = vertices[node][:cost]
    if dests = edges[node]?
      dests.each do |dest, cost|
        if (v = vertices[dest]?).nil? || v[:cost] > current_cost + cost
          vertices[dest] = { cost: current_cost + cost, prev: node }
          queue.push dest
        end
      end
    end
  end
  vertices.map {|vertex, t|
    # reconstruct path
    path = [vertex]
    prev = t[:prev]
    while prev != :""
      path << prev
      prev = vertices[prev][:prev]
    end
    { path.reverse, t[:cost] }
  }
end

edges = [{:a, :b, 7},  {:a, :c, 9}, {:a, :f, 14}, {:b, :c, 10}, {:b, :d, 15},
         {:c, :d, 11}, {:c, :f, 2}, {:d, :e, 6},  {:e, :f, 9}]

# show the shortest path to each reachable vertex
puts "Shortest paths from :a to each reachable vertex:"
pp shortest_paths(edges, :a)

# interpret the output from above and use it to output
# the shortest path from a to e and f
puts "\nShortest paths from :a to :e and :f:"
pp shortest_paths(edges, :a).select {|path, _| path[0] == :a && path[-1].in? [:e, :f] }
