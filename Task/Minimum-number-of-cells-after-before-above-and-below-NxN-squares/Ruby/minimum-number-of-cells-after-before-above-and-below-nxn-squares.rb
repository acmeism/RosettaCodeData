def dist2edge(n)
  width = (n/2).to_s.size+1
  m = n-1
  (0..m).map do |x|
    (0..m).map{|y| [x, y, m-x, m-y].min.to_s.center(width) }.join
  end
end

puts dist2edge(10)
