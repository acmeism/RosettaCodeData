require 'prime'

def unprimable?(n)
  digits = %w(0 1 2 3 4 5 6 7 8 9)
  s = n.to_s
  size = s.size
  (size-1).downto(0) do |i|
    digits.each do |d|
      cand = s.dup
      cand[i]=d
      return false if cand.to_i.prime?
    end
  end
  true
end
ups = Enumerator.new {|y| (1..).each{|n| y << n if unprimable?(n)} }

ar = ups.first(600)
puts "First 35 unprimables:", ar[0,35].join(" ")
puts "\n600th unprimable:", ar.last, ""
(0..9).each do |d|
  print "First unprimeable with last digit #{d}: "
  puts (1..).detect{|k| unprimable?(k*10+d)}*10 + d
end
