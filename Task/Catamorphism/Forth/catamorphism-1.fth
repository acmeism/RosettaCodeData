: lowercase? ( c -- f )
  [char] a [ char z 1+ ] literal within ;

: char-upcase ( c -- C )
  dup lowercase? if bl xor then ;
