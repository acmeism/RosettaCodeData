include FMS2VT.f

\ A singleton is created by using normal Forth data
\ allocation words such as value or variable as instance variables.
\ Any number of instances of a singleton class may be
\ instantiated but messages will all operate on the same shared data
\ so it is the same as if only one object has been created.
\ The data name space will remain private to the class.

:class singleton
  0 value a
  0 value b
  :m printa a . ;m
  :m printb b . ;m
  :m add-a ( n -- ) a + to a ;m
  :m add-b ( n -- ) b + to b ;m
;class

singleton s1
singleton s2
singleton s3

4 s1 add-a
9 s2 add-b
s3 printa \ => 4
s3 printb \ => 9
s1 printb \ => 9
s2 printa \ => 4
