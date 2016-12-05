def proportion(base):
  def count(stream): reduce stream as $i (0; . + 1);
  . as $n
  | (base - 1) as $b
  | count( range(1; 1+$n) | select( . % $b == (.*.) % $b) ) / $n ;
