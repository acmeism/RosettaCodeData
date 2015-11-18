[
'the cat sat on the mat', 'mat cat',
'the cat sat on the mat', 'cat mat',
'A B C A B C A B C'     , 'C A C A',
'A B C A B D A B E'     , 'E A D A',
'A B'                   , 'B',
'A B'                   , 'B A',
'A B B A'               , 'B A'
].each_slice(2) do |s, o|
  s, o = s.split, o.split
  print [s, '|' , o, ' -> '].join(' ')
  from = 0
  o.each_slice(2) do |x, y|
    next unless y
    if x > y && (s[from..-1].include? x) && (s[from..-1].include? y)
      new_from = [s.index(x), s.index(y)].max+1
      if s[from..-1].index(x) > s[from..-1].index(y)
        s[s.index(x)+from], s[s.index(y)+from] = s[s.index(y)+from], s[s.index(x)+from]
        from = new_from
      end
    end
  end
  puts s.join(' ')
end
