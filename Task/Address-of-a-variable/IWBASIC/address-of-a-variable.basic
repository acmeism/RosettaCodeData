== Get ==

There are at least three ways to get the address of a variable in IWBASIC. The first is to use the address of operator:

DEF X:INT
PRINT &X
'This will print in the console window (after OPENCONSOLE is issued.)
'To Print in an open window the appropriate Window variable is specified, e.g., PRINT Win,&X.

The second is to use a pointer:

DEF X:INT
DEF pPointer:POINTER
pPointer=X

The third is to use the Windows API function Lstrcpy. That is done in the same way as the Creative Basic example;
however, the function would be declared as follows: DECLARE IMPORT,Lstrcpy(P1:POINTER,P2:POINTER),INT.

== Set ==

It appears to the author that the closest one can come to being able to assign an address to a variable is to set
which bytes will be used to store a variable in a block of reserved memory:

DEF pMem as POINTER
pMem = NEW(CHAR,1000) : 'Get 1000 bytes to play with
#<STRING>pMem = "Copy a string into memory"
pMem += 100
#<UINT>pMem = 34234: 'Use bytes 100-103 to store a UINT
DELETE pMem
