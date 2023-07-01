ar = [
  ['the cat sat on the mat', 'mat cat'],
  ['the cat sat on the mat', 'cat mat'],
  ['A B C A B C A B C'     , 'C A C A'],
  ['A B C A B D A B E'     , 'E A D A'],
  ['A B'                   , 'B'      ],
  ['A B'                   , 'B A'    ],
  ['A B B A'               , 'B A'    ]
]

res  = ar.map do |m,n|
  mm = m.dup
  nn = n.split
  nn.each {|item| mm.sub!(item, "%s")} #sub! only subs the first match
  mm % nn #"the %s sat on the %s" % [mat", "cat"] #does what you hope it does.
end

puts res
