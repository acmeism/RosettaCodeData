require 'prime'

def a(n)
  return 1 if n == 1 || n.prime?
  (n/2).downto(1).detect{|d| n.remainder(d) == 0}
end

(1..100).map{|n| a(n).to_s.rjust(3)}.each_slice(10){|slice| puts slice.join}
