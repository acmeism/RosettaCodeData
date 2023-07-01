def four_squares(low, high, unique=true, show=unique)
  f = -> (a,b,c,d,e,f,g) {[a+b, b+c+d, d+e+f, f+g].uniq.size == 1}
  if unique
    uniq = "unique"
    solutions = [*low..high].permutation(7).select{|ary| f.call(*ary)}
  else
    uniq = "non-unique"
    solutions = [*low..high].repeated_permutation(7).select{|ary| f.call(*ary)}
  end
  if show
    puts " " + [*"a".."g"].join("  ")
    solutions.each{|ary| p ary}
  end
  puts "#{solutions.size} #{uniq} solutions in #{low} to #{high}"
  puts
end

[[1,7], [3,9]].each do |low, high|
  four_squares(low, high)
end
four_squares(0, 9, false)
