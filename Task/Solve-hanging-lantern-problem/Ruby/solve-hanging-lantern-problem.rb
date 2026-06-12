Factorial = Hash.new{|h, k| h[k] = k * h[k-1] } # a memoized factorial
Factorial[0] = 1

def count_perms_with_reps(ar)
  Factorial[ar.sum] / ar.inject{|prod, m| prod * Factorial[m]}
end

ar, input = [], ""
puts "Input column heights in sequence (empty line to end input):"
ar << input.to_i until (input=gets) == "\n"
puts "There are #{count_perms_with_reps(ar)} ways to take these #{ar.size} columns down."
