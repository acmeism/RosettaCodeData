# Solitaire Like Puzzle Solver - Nigel Galloway: October 18th., 2014
G = [[0,1,3],[0,2,5],[1,3,6],[1,4,8],[2,4,7],[2,5,9],[3,4,5],[3,6,10],[3,7,12],[4,7,11],[4,8,13],[5,8,12],[5,9,14],[6,7,8],[7,8,9],[10,11,12],[11,12,13],[12,13,14],
     [3,1,0],[5,2,0],[6,3,1],[8,4,1],[7,4,2],[9,5,2],[5,4,3],[10,6,3],[12,7,3],[11,7,4],[13,8,4],[12,8,5],[14,9,5],[8,7,6],[9,8,7],[12,11,10],[13,12,11],[14,13,12]]
FORMAT = (1..5).map{|i| " "*(5-i)+"%d "*i+"\n"}.join+"\n"
def solve n,i,g
  return "Solved" if i == 1
  return false unless n[g[0]]==0 and n[g[1]]==1 and n[g[2]]==1
    e = n.clone; g.each{|n| e[n] = 1 - e[n]}
    l=false; G.each{|g| l=solve(e,i-1,g); break if l}
  return l ? "#{g[0]} to #{g[2]}\n" + FORMAT % e + l : l
end
puts FORMAT % (N=[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1])
l=false; G.each{|g| l=solve(N,N.inject(:+),g); break if l}
puts l ? l : "No solution found"
