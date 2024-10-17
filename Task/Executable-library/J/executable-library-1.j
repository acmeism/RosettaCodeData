#!/usr/bin/ijconsole
hailseq=: -:`(1 3&p.)@.(2&|) ^:(1 ~: ]) ^:a:"0
9!:29]1
9!:27'main 0'
main=:3 :0
  echo 'Hailstone sequence for the number 27'
  echo hailseq 27
  echo ''
  echo 'Finding number with longest hailstone sequence which is'
  echo 'less than 100000 (and finding that sequence length):'
  echo (I.@(= >./),>./) #@hailseq i.1e5
)
