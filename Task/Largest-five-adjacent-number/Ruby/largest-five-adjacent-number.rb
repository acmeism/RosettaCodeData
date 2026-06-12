digits = %w(0 1 2 3 4 5 6 7 8 9)
arr = Array.new(1000){ digits.sample }
puts "minimum sequence %s, maximum sequence %s." % arr.each_cons(5).minmax_by{|slice| slice.join.to_i}.map(&:join)
