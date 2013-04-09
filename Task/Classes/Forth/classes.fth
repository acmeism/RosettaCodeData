:class MyClass <super Object

  int memvar

  :m ClassInit: ( -- )
       ClassInit: super
       1 to memvar ;m

  :m ~: ( -- )  ." Final " show: [ Self ] ;m

  :m set: ( n -- )  to memvar ;m
  :m show: ( -- ) ." Memvar = " memvar . ;m

;class
