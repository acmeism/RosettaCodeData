/*REXX program to compute the  CRC-32  (Cylic Redundancy Check, 32 bit),*/
/*  checksum for a given string  [as described in ISO 3309, ITU-T V.42].*/
               a_string = 'The quick brown fox jumps over the lazy dog'
               b_string = 'Generate CRC32 Checksum For Byte Array Example'
call show a_string
call show b_string
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show:  procedure;   parse arg Xstring;    say
checksum=CRC_32(Xstring)               /*invoke  CRC_32  to create a CRC*/
say
say center(' input string [length of' length(Xstring) "bytes] ",79,'─')
say Xstring                            /*show the string on its own line*/
say
checksum=bitxor(checksum,'ffFFffFF'x)  /*final convolution for checksum.*/
say 'hex CRC-32 checksum =' c2x(checksum) left('',15),
    "dec CRC-32 checksum =" c2d(checksum)     /*show CRC-32 in hex & dec*/
return
/*──────────────────────────────────CRC_32 subroutine───────────────────*/
CRC_32:  procedure;   parse arg !,$    /*2nd arg is for multi-invokes.  */

  do i=0  to 255;     z=d2c(i)         /*build the 8-bit indexed table. */
  r=right(z,4,'0'x)                    /*insure the  R  is 32 bits.     */
           do j=0 for 8                /*handle each bit of rightmost 8.*/
           rb=x2b(c2x(r))              /*convert char ──► hex ──► binary*/
           _=right(rb,1)               /*remember right-most bit for IF.*/
           r=x2c(b2x(0||left(rb,31)))  /*shift it right (unsigned) 1 bit*/
           if _\==0 then r=bitxor(r,'edb88320'x)   /*bit XOR grunt-work.*/
           end   /*j*/
  !.z=r
  end            /*i*/

$=bitxor(word($ '0000000'x,1),'ffFFffFF'x)  /*use user's CRC or default.*/
         do k=1  for length(!)         /*start crunching the input data.*/
         ?=bitxor(right($,1),substr(!,k,1)); $=bitxor('0'x||left($,3),!.?)
         end   /*k*/
return $                               /*return with da money to invoker*/
