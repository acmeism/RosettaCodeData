::
:: Greatest common divisor (gcd), Euclid's algorithm.
::
|=  [a=@ud b=@ud]
^-  @ud
?>  (gth b 0)
?:  =((mod a b) 0)
  b
$(a b, b (mod a b))
