\ fetch and store usage examples
VARIABLE MYINT1
VARIABLE MYINT2
2VARIABLE DOUBLE1
2VARIABLE DOUBLE2

MYINT1 @  MYINT2 !
MYDOUBLE 2@ MYDOUBLE 2!

\ record example using this convention

1000000 RECORDS PERSONEL

1 PERSONEL RECORD@  \ read Record 1 and put pointer on data stack

HR_RECORD 992 PERSONEL RECORD! \ store HR_RECORD
