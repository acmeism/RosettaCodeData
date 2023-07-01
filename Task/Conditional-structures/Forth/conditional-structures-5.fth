: switch
  CREATE ( default-xt [count-xts] count -- ) DUP , 0 DO , LOOP ,
  DOES> ( u -- ) TUCK @ MIN 1+ CELLS + @ EXECUTE ;

  :NONAME ." Out of range!" ;
  :NONAME ." nine" ;
  :NONAME ." eight" ;
  :NONAME ." seven" ;
  :NONAME ." six" ;
  :NONAME ." five" ;
  :NONAME ." four" ;
  :NONAME ." three" ;
  :NONAME ." two" ;
  :NONAME ." one" ;
  :NONAME ." zero" ;
10 switch digit

 8 digit   \ eight
34 digit   \ Out of range!
