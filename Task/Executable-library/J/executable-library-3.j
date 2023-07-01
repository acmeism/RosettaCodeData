require '~temp/hailseq.ijs'
9!:29]1
9!:27'main 0'
main=:3 :0
  smoutput 'Finding most frequent hailstone sequence length for'
  smoutput 'Hailstone sequences for whole numbers less than 100000:'
  smoutput  {:{.\:~ (#/.~,.~.) #@hailseq }.i.1e5
)
