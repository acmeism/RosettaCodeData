for n in (-10000..10000).step(17)
  raise unless n == int_from_words(wordify(n))
end

for n in 0...20
  raise unless 13**n == int_from_words(wordify(13**n))
end

puts "##\n## These tests show <==> for a successful round trip, otherwise <??>\n##"
for n in [0, -3, 5, -7, 11, -13, 17, -19, 23, -29]
  txt = wordify(n)
  num = int_from_words(txt)
  puts '%+4i <%s> %s' % [n, n==num ? '==' : '??', txt]
end
puts

n = 201021002001
loop do
  txt = wordify(n)
  num = int_from_words(txt)
  puts '%12i <%s> %s' % [n, n==num ? '==' : '??', txt]
  break if n==0
  n /= -10
end
