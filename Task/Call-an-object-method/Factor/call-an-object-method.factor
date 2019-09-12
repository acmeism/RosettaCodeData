USING: accessors io kernel literals math sequences ;
IN: rosetta-code.call-a-method

! Define some classes.
SINGLETON: dog
TUPLE: cat sassiness ;

! Define a constructor for cat.
C: <cat> cat

! Define a generic word that dispatches on the object at the top
! of the data stack.
GENERIC: speak ( obj -- )

! Define methods in speak which specialize on various classes.
M: dog speak drop "Woof!" print ;
M: cat speak sassiness>> 0.5 > "Hiss!" "Meow!" ? print ;
M: object speak drop "I don't know how to speak!" print ;

! Place some objects of various classes in a sequence.
${ dog 0.75 <cat> 0.1 <cat> 10 }
! Call speak, a method, just like any other word.
[ speak ] each
