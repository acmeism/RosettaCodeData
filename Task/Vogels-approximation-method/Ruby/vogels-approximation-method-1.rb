# VAM
#
#  Nigel_Galloway
#  September 1st., 2013
COSTS  = {W: {A: 16, B: 16, C: 13, D: 22, E: 17},
          X: {A: 14, B: 14, C: 13, D: 19, E: 15},
          Y: {A: 19, B: 19, C: 20, D: 23, E: 50},
          Z: {A: 50, B: 12, C: 50, D: 15, E: 11}}
demand = {A: 30, B: 20, C: 70, D: 30, E: 60}
supply = {W: 50, X: 60, Y: 50, Z: 50}
COLS = demand.keys
res = {}; COSTS.each_key{|k| res[k] = Hash.new(0)}
g = {}; supply.each_key{|x| g[x] = COSTS[x].keys.sort_by{|g| COSTS[x][g]}}
        demand.each_key{|x| g[x] = COSTS.keys.sort_by{|g| COSTS[g][x]}}

until g.empty?
  d = demand.collect{|x,y| [x, z = COSTS[g[x][0]][x], g[x][1] ? COSTS[g[x][1]][x] - z : z]}
  dmax = d.max_by{|n| n[2]}
  d = d.select{|x| x[2] == dmax[2]}.min_by{|n| n[1]}
  s = supply.collect{|x,y| [x, z = COSTS[x][g[x][0]], g[x][1] ? COSTS[x][g[x][1]] - z : z]}
  dmax = s.max_by{|n| n[2]}
  s = s.select{|x| x[2] == dmax[2]}.min_by{|n| n[1]}
  t,f = d[2]==s[2] ? [s[1], d[1]] : [d[2],s[2]]
  d,s = t > f ? [d[0],g[d[0]][0]] : [g[s[0]][0],s[0]]
  v = [supply[s], demand[d]].min
  res[s][d] += v
  demand[d] -= v
  if demand[d] == 0 then
    supply.reject{|k, n| n == 0}.each_key{|x| g[x].delete(d)}
    g.delete(d)
    demand.delete(d)
  end
  supply[s] -= v
  if supply[s] == 0 then
    demand.reject{|k, n| n == 0}.each_key{|x| g[x].delete(s)}
    g.delete(s)
    supply.delete(s)
  end
end

COLS.each{|n| print "\t", n}
puts
cost = 0
COSTS.each_key do |g|
  print g, "\t"
  COLS.each do |n|
    y = res[g][n]
    print y if y != 0
    cost += y * COSTS[g][n]
    print "\t"
  end
  puts
end
print "\n\nTotal Cost = ", cost
