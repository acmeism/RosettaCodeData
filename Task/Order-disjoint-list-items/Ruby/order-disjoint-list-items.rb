test_data = [
'the cat sat on the mat', 'mat cat',
'the cat sat on the mat', 'cat mat',
'A B C A B C A B C'     , 'C A C A',
'A B C A B D A B E'     , 'E A D A',
'A B'                   , 'B',
'A B'                   , 'B A',
'A B B A'               , 'B A',
'the cat sat on the chair', 'chair cat']

test_data.each_slice(2) do |str, order|
  result, order_items = str.dup, order.split
  re = Regexp.union(order_items.uniq)
  offsets = str.enum_for(:scan, re).map{ ($~.begin(0) ... $~.end(0)) }  # $~ is last MatchData object
  order_items.zip(offsets).reverse_each{|item, offset| result[offset] = item}
  puts "Data M: %-24s Order N: %-10s-> M' %-12s" % [str, order, result]
end
