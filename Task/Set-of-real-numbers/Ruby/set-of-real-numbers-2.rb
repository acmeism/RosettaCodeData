p a = Rset[1,2,false]
[1,2,3].each{|x|puts "#{x} => #{a.include?(x)}"}
puts
a = Rset[0,2,false]             #=> Rset[0,2)
b = Rset(1,3)                   #=> Rset(1,3)
c = Rset[0,1,false]             #=> Rset[0,1)
d = Rset(2,3,true)              #=> Rset(2,3]
puts "#{a} | #{b} -> #{a | b}"
puts "#{c} | #{d} -> #{c | d}"
puts
puts "#{a} & #{b} -> #{a & b}"
puts "#{c} & #{d} -> #{c & d}"
puts "(#{c} & #{d}).empty? -> #{(c&d).empty?}"
puts
puts "#{a} - #{b} -> #{a - b}"
puts "#{a} - #{a} -> #{a - a}"
e = Rset(0,3,true)
f = Rset[1,2]
puts "#{e} - #{f} -> #{e - f}"

puts "\nTest :"
test_set = [["(0, 1]", "|", "[0, 2)"],
            ["[0, 2)", "&", "(1, 2]"],
            ["[0, 3)", "-", "(0, 1)"],
            ["[0, 3)", "-", "[0, 1]"] ]
test_set.each do |sa,ope,sb|
  str = "#{sa} #{ope} #{sb}"
  e = eval("Rset.from_s(sa) #{ope} Rset.from_s(sb)")
  puts "%s -> %s" % [str, e]
  (0..2).each{|i| puts "  #{i} : #{e.include?(i)}"}
end

puts
test_set = ["x = Rset[0,2] | Rset(3,7) | Rset[8,10]",
            "y = Rset(7,9) | Rset(5,6) | Rset[1,4]",
            "x | y", "x & y", "x - y", "y - x", "x ^ y",
            "y ^ x == (x | y) - (x & y)"]
x = y = nil
test_set.each {|str| puts "#{str} -> #{eval(str)}"}

puts
inf = 1.0 / 0.0             # infinity
puts "a = #{a = Rset(-inf,inf)}"
puts "b = #{b = Rset.from_s('[1/3,11/7)')}"
puts "a - b -> #{a - b}"
