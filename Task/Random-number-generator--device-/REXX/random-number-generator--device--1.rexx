/*REXX program  generates and displays a random  32-bit  number  using the  RANDOM  BIF.*/
numeric digits 10                                /*ensure REXX has enough decimal digits*/
_=2**16                                          /*a handy─dandy constant to have around*/
r#= random(0, _-1) * _    +    random(0, _-1)    /*generate an unsigned 32-bit random #.*/
say r#                                           /*stick a fork in it,  we're all done. */
