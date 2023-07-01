oprimes=: {{ NB. all primes of order y
  p:(+i.)/-/\ p:inv +/\1 9*10^y
}}

obrill=: {{ NB. all brilliant numbers of order y primes
  ~.,*/~oprimes y
}}

brillseq=: {{ NB. sequences of brilliant numbers up through order y-1 primes
  /:~;obrill each i.y
}}
