tobase=: (a.{~;48 97(+ i.)each 10 26) {~ #.inv
isrhonda=: (*/@:(#.inv) = (* +/@q:))"0

task=: {{
  for_base.(#~ 0=1&p:) }.1+i.36 do.
    k=.i.0
    block=. 1+i.1e4
    while. 15>#k do.
      k=. k, block#~ base isrhonda block
      block=. block+1e4
    end.
    echo ''
    echo 'First 15 Rhondas in',b=.' base ',':',~":base
    echo 'In base 10: ',":15{.k
    echo 'In',;:inv b;base tobase each 15{.k
  end.
}}

   task''
