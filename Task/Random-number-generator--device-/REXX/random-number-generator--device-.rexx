/*REXX program generates a random  32-bit  number using the  RANDOM bif.*/
/*───────── The  32-bit  random number is unsigned and constructed from */
/*───────── two smaller 16-bit  numbers,  and it's expressed in decimal.*/
/*───────── Note: the REXX  random  bif  has a maximum range of 100,000.*/

numeric digits 10                      /*ensure REXX has enough room.   */
_=2**16                                /*a handy-dandy constant to have.*/

say random(0,_-1)*_+random(0,_-1)      /*gen an unsigned 32-bit random #*/
