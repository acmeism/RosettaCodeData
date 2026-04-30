       identification division.
       program-id. overflowing.

       data division.
       working-storage section.
       01 bit8-sized       usage binary-char.          *> standard
       01 bit16-sized      usage binary-short.         *> standard
       01 bit32-sized      usage binary-long.          *> standard
       01 bit64-sized      usage binary-double.        *> standard
       01 bit8-unsigned    usage binary-char unsigned. *> standard

       01 nebulous-size    usage binary-c-long.        *> extension

       01 picture-size     picture s999.               *> standard

      *> ***************************************************************
       procedure division.

      *> 32 bit signed integer
       subtract 2147483647 from zero giving bit32-sized
       display bit32-sized

       subtract 1 from bit32-sized giving bit32-sized
           ON SIZE ERROR display "32bit signed SIZE ERROR"
       end-subtract
      *> value was unchanged due to size error trap and trigger
       display bit32-sized
       display space

      *> 8 bit unsigned, size tested, invalid results discarded
       add -257 to zero giving bit8-unsigned
           ON SIZE ERROR display "bit8-unsigned SIZE ERROR"
       end-add
       display bit8-unsigned

      *> programmers can ignore the safety features
       compute bit8-unsigned = -257
       display "you asked for it: " bit8-unsigned
       display space

      *> fixed size
       move 999 to picture-size
       add 1 to picture-size
           ON SIZE ERROR display "picture-sized SIZE ERROR"
       end-add
       display picture-size

      *> programmers doing the following, inadvertently,
      *>   do not stay employed at banks for long
       move 999 to picture-size
       add 1 to picture-size
      *> intermediate goes to 1000, left end truncated on storage
       display "you asked for it: " picture-size

       add 1 to picture-size
       display "really? you want to keep doing this?: " picture-size
       display space

      *> C values are undefined by spec, only minimums givens
       display "How many bytes in a C long? "
               length of nebulous-size
               ", varies by platform"
       display "Regardless, ON SIZE ERROR will catch any invalid result"

      *> on a 64bit machine, C long of 8 bytes
       add 1 to h'ffffffffffffffff' giving nebulous-size
           ON SIZE ERROR display "binary-c-long SIZE ERROR"
       end-add
       display nebulous-size
      *> value will still be in initial state, GnuCOBOL initializes to 0
      *> value now goes to 1, no size error, that ship has sailed
       add 1 to nebulous-size
           ON SIZE ERROR display "binary-c-long size error"
       end-add
       display "error state is not persistent: ", nebulous-size

       goback.
       end program overflowing.
