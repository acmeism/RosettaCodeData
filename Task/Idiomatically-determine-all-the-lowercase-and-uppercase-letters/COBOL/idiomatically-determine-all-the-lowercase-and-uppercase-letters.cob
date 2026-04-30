       identification division.
       program-id. determine.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 tx pic x.
       01 lower-8bit pic x(256).
       01 upper-8bit pic x(256).

      *> 01 tn pic n.
      *> 01 lower-set pic n(65536).
      *> 01 upper-set pic n(65536).

       01 low-slide usage index.
       01 high-slide usage index.

       procedure division.
       determining.

      *> COBOL pic x, an 8 bit data encoding
       set low-slide to 0
       set high-slide to 0
       perform varying tally from 1 by 1 until tally > 256
           move char(tally) to tx
           if tx is alphabetic-lower then
               set low-slide up by 1
               move tx to lower-8bit(low-slide:1)
           end-if
           if tx is alphabetic-upper then
               set high-slide up by 1
               move tx to upper-8bit(high-slide:1)
           end-if
       end-perform
       if low-slide equal 0 then
           display "no lower case letters detected" upon syserr
       else
           display lower-8bit(1:low-slide)
       end-if
       if high-slide equal 0 then
           display "no upper case letters detected" upon syserr
       else
           display upper-8bit(1:high-slide)
       end-if

      *> COBOL standard NATIONAL data type, a 16 bit encoding
      *> commented out: task description may not want extended encodings

      *> set low-slide to 0
      *> set high-slide to 0
      *> perform varying tally from 1 by 1 until tally > 65536
      *>     move char-national(tally) to tn
      *>     if tn is alphabetic-lower then
      *>         set low-slide up by 1
      *>         move tn to lower-set(low-slide:1)
      *>     end-if
      *>     if tn is alphabetic-upper then
      *>         set high-slide up by 1
      *>         move tn to upper-set(high-slide:1)
      *>     end-if
      *> end-perform
      *> if low-slide equal 0 then
      *>     display "no lower case letters detected" upon syserr
      *> else
      *>     display lower-set(1:low-slide)
      *> end-if
      *> if high-slide equal 0 then
      *>     display "no upper case letters detected" upon syserr
      *> else
      *>     display upper-set(1:high-slide)
      *> end-if

       goback.
       end program determine.
