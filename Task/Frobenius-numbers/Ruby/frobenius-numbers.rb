require 'prime'

Prime.each_cons(2) do |p1, p2|
  f = p1*p2-p1-p2
  break if f > 10_000
  puts f
end
