hailseq=: -:`(1 3&p.)@.(2&|) ^:(1 ~: ]) ^:a:"0
9!:29]1
9!:27'main 0'
main=:3 :0
  smoutput 'Hailstone sequence for the number 27'
  smoutput hailseq 27
  smoutput ''
  smoutput 'Finding number with longest hailstone sequence which is'
  smoutput 'less than 100000 (and finding that sequence length):'
  smoutput (I.@(= >./),>./) #@hailseq i.1e5
)
