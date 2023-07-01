class String
  def wc
  n = Hash.new(0)
  downcase.scan(/[A-Za-zÀ-ÿ]+/) { |g| n[g] += 1 }
  n.sort{|n,g| n[1]<=>g[1]}
  end
end

open('135-0.txt') { |n| n.read.wc[-10,10].each{|n| puts n[0].to_s+"->"+n[1].to_s} }
