def check(list)
  a, b, c, d, e, f, g = list
  first = a + b
  {b + c + d, d + e + f, f + g}.all? &.==(first)
end

def four_squares(low, high, unique = true, show = unique)
  solutions = [] of Array(Int32)
  if unique
    uniq = "unique"
    (low..high).to_a.each_permutation(7, true) { |ary| solutions << ary.clone if check(ary) }
  else
    uniq = "non-unique"
    (low..high).to_a.each_repeated_permutation(7, true) { |ary| solutions << ary.clone if check(ary) }
  end
  if show
    puts " " + ("a".."g").join("  ")
    solutions.each { |ary| p ary }
  end
  puts "#{solutions.size} #{uniq} solutions in #{low} to #{high}"
  puts
end

{ {1, 7}, {3, 9} }.each do |(low, high)|
  four_squares(low, high)
end
four_squares(0, 9, false)
