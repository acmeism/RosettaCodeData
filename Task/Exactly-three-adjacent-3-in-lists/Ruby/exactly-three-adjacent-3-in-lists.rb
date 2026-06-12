tests = [[9,3,3,3,2,1,7,8,5],
         [5,2,9,3,3,7,8,4,1],
         [1,4,3,6,7,3,8,3,2],
         [1,2,3,4,5,6,7,8,9],
         [4,6,8,7,2,3,3,3,1],
         [3,3,3,1,2,4,5,1,3],
         [0,3,3,3,3,7,2,2,6],
         [3,3,3,3,3,4,4,4,4]]

(1..4).each do |n|
  c = [n]*n
  puts "Contains exactly #{n} #{n}s, consecutive:"
  tests.each { |t| puts "#{t.inspect} : #{t.count(n)==n && t.each_cons(n).any?{|chunk| chunk == c }}" }
end
