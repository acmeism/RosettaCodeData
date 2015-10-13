/*REXX program computes the  CRC─32  (32 bit Cyclic Redundancy Check) checksum*/
/*─────────────────for a given string  [as described in ISO 3309, ITU─T V.42].*/

call show  'The quick brown fox jumps over the lazy dog'         /*1st string.*/
call show  'Generate CRC32 Checksum For Byte Array Example'      /*2nd    "   */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
CRC_32:  procedure;   parse arg !,$    /*2nd arg: it has repeated─invocations.*/
                                       /* [↓]  build an  8─bit  indexed table,*/
  do i=0  for 256;    z=d2c(i)         /*                  one byte at a time.*/
  r=right(z, 4, '0'x)                  /*insure the  "R"   is thirty-two bits.*/

        do j=0  for 8                  /*handle each bit of rightmost 8 bits. */
        rb=x2b(c2x(r))                 /*convert character ──► hex ──► binary.*/
        _=right(rb,1)                  /*remember the right─most bit for  IF. */
        r=x2c(b2x(0 || left(rb, 31)))  /*shift it right (an unsigned)  1  bit.*/
        if _\==0  then r=bitxor(r, 'edb88320'x)  /*this is bit XOR grunt─work.*/
        end    /*j*/
  !.z=r                                /*assign to an eight─bit index table.  */
  end          /*i*/

$=bitxor(word($ '0000000'x,1),'ffFFffFF'x)  /*use the user's CRC or a default.*/
         do k=1  for length(!)              /*start crunching the input data. */
         ?=bitxor(right($, 1), substr(!, k, 1))
         $=bitxor('0'x || left($, 3),  !.?)
         end   /*k*/
return $                               /*return with da money to the invoker. */
/*────────────────────────────────────────────────────────────────────────────*/
show:  procedure;   parse arg Xstring;   numeric digits 12;      say;     say
checksum=CRC_32(Xstring)                     /*invoke  CRC_32 to create a CRC.*/
checksum=bitxor(checksum,'ffFFffFF'x)        /*final convolution for checksum.*/
say center(' input string [length of' length(Xstring) "bytes] ", 79, '═')
say Xstring                                  /*show the string on its own line*/
say                                          /*↓↓↓↓↓↓↓↓↓↓↓↓  is fifteen blanks*/
say  'hex CRC-32 checksum ='   c2x(checksum)   left('', 15),
     "dec CRC-32 checksum ="   c2d(checksum) /*show the CRC-32 in hex and dec.*/
return
