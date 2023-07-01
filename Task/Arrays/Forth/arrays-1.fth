create MyArray 1 , 2 , 3 , 4 , 5 ,  5 cells allot
here constant MyArrayEnd

30 MyArray 7 cells + !
MyArray 7 cells + @ .    \ 30

: .array  MyArrayEnd MyArray do I @ .  cell +loop ;
