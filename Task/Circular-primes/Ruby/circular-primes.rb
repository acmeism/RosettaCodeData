require 'gmp'
require 'prime'
candidate_primes = Enumerator.new do |y|
  DIGS = [1,3,7,9]
  [2,3,5,7].each{|n| y << n.to_s}
  (2..).each do |size|
    DIGS.repeated_permutation(size) do |perm|
      y << perm.join if (perm == min_rotation(perm)) && GMP::Z(perm.join).probab_prime? > 0
    end
  end
end

def min_rotation(ar) = Array.new(ar.size){|n| ar.rotate(n)}.min

def circular?(num_str)
  chars = num_str.chars
  return GMP::Z(num_str).probab_prime? > 0 if chars.all?("1")
  chars.size.times.all? do
   GMP::Z(chars.rotate!.join).probab_prime? > 0
   # chars.rotate!.join.to_i.prime?
  end
end

puts "First 19 circular primes:"
puts candidate_primes.lazy.select{|cand| circular?(cand)}.take(19).to_a.join(", "),""
puts "First 5 prime repunits:"
reps = Prime.each.lazy.select{|pr| circular?("1"*pr)}.take(5).to_a
puts  reps.map{|r| "R" + r.to_s}.join(", "), ""
[5003, 9887, 15073, 25031].each {|rep| puts "R#{rep} circular_prime ? #{circular?("1"*rep)}" }
