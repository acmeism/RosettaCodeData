require 'set'

def bron_kerbosch_v2(r, p, x, g, cliques)
  if p.empty? && x.empty?
    if r.size > 2
      cliques << r.to_a.sort
    end
    return
  end

  pivot = (p | x).max_by { |v| g[v]&.size.to_i }

  if pivot
    neighbors = g[pivot] || Set.new
    candidates = p - neighbors

    candidates.each do |v|
      new_r = r.dup.add(v)
      neighbors_v = g[v] || Set.new
      new_p = p & neighbors_v
      new_x = x & neighbors_v

      bron_kerbosch_v2(new_r, new_p, new_x, g, cliques)

      p.delete(v)
      x.add(v)
    end
  end
end

def main
  input = [
    ['a', 'b'], ['b', 'a'], ['a', 'c'], ['c', 'a'],
    ['b', 'c'], ['c', 'b'], ['d', 'e'], ['e', 'd'],
    ['d', 'f'], ['f', 'd'], ['e', 'f'], ['f', 'e']
  ]

  graph = Hash.new { |hash, key| hash[key] = Set.new }
  input.each do |src, dest|
    graph[src].add(dest)
  end

  r = Set.new
  p = graph.keys.to_set
  x = Set.new
  cliques = []

  bron_kerbosch_v2(r, p, x, graph, cliques)

  sorted_cliques = cliques.sort

  sorted_cliques.each do |clique|
    puts clique.join(', ')
  end
end

main
