def floyd_warshall(n, edge)
  dist = Array.new(n){|i| Array.new(n){|j| i==j ? 0 : Float::INFINITY}}
  nxt = Array.new(n){Array.new(n)}
  edge.each do |u,v,w|
    dist[u-1][v-1] = w
    nxt[u-1][v-1] = v-1
  end

  n.times do |k|
    n.times do |i|
      n.times do |j|
        if dist[i][j] > dist[i][k] + dist[k][j]
          dist[i][j] = dist[i][k] + dist[k][j]
          nxt[i][j] = nxt[i][k]
        end
      end
    end
  end

  puts "pair     dist    path"
  n.times do |i|
    n.times do |j|
      next  if i==j
      u = i
      path = [u]
      path << (u = nxt[u][j])  while u != j
      path = path.map{|u| u+1}.join(" -> ")
      puts "%d -> %d  %4d     %s" % [i+1, j+1, dist[i][j], path]
    end
  end
end

n = 4
edge = [[1, 3, -2], [2, 1, 4], [2, 3, 3], [3, 4, 2], [4, 2, -1]]
floyd_warshall(n, edge)
