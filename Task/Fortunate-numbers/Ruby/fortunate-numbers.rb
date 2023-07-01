require "gmp"

primorials = Enumerator.new do |y|
  cur = prod = 1
  loop {y << prod *= (cur = GMP::Z(cur).nextprime)}
end

limit = 50
fortunates = []
while fortunates.size < limit*2 do
  prim = primorials.next
  fortunates << (GMP::Z(prim+2).nextprime - prim)
  fortunates = fortunates.uniq.sort
end

p fortunates[0, limit]
