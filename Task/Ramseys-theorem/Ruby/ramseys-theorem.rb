a = Array.new(17){['0'] * 17}
17.times{|i| a[i][i] = '-'}
4.times do |k|
  17.times do |i|
    j = (i + 2 ** k) % 17
    a[i][j] = a[j][i] = '1'
  end
end
a.each {|row| puts row.join(' ')}
# check taken from Raku version
(0...17).to_a.combination(4) do |quartet|
  links = quartet.combination(2).map{|i,j| a[i][j].to_i}.reduce(:+)
  abort "Bogus" unless 0 < links && links < 6
end
puts "Ok"
