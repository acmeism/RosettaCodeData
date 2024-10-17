require '~temp/hailseq.ijs'
9!:29]1
9!:27'main 0'
main=:3 :0
  echo 'Finding most frequent hailstone sequence length for'
  echo 'Hailstone sequences for whole numbers less than 100000:'
  echo  {:{.\:~ (#/.~,.~.) #@hailseq }.i.1e5
)
