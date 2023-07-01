def order_disjoint(m,n)
  print "#{m} | #{n} -> "
  m, n = m.split, n.split
  from = 0
  n.each_slice(2) do |x,y|
    next unless y
    sd = m[from..-1]
    if x > y && (sd.include? x) && (sd.include? y) && (sd.index(x) > sd.index(y))
      new_from = m.index(x)+1
      m[m.index(x)+from], m[m.index(y)+from] = m[m.index(y)+from], m[m.index(x)+from]
      from = new_from
    end
  end
  puts m.join(' ')
end

[
  ['the cat sat on the mat', 'mat cat'],
  ['the cat sat on the mat', 'cat mat'],
  ['A B C A B C A B C'     , 'C A C A'],
  ['A B C A B D A B E'     , 'E A D A'],
  ['A B'                   , 'B'      ],
  ['A B'                   , 'B A'    ],
  ['A B B A'               , 'B A'    ]
].each {|m,n| order_disjoint(m,n)}
