n = 5
m = Array.new(n){Array.new(n)}
pos, side = -1, n
for i in 0 .. (n-1)/2
  (0...side).each{|j| m[i][i+j]     = (pos+=1) }
  (1...side).each{|j| m[i+j][n-1-i] = (pos+=1) }
  side -= 2
  side.downto(0) {|j| m[n-1-i][i+j] = (pos+=1) }
  side.downto(1) {|j| m[i+j][i]     = (pos+=1) }
end

fmt = "%#{(n*n-1).to_s.size}d " * n
puts m.map{|row| fmt % row}
