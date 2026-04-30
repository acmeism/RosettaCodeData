       identification division.
       program-id.             bio.
       environment division.
      *************************************************************
      **** To execute on command line enter program name followed
      **** by birth date ccyymmdd and then target date.
      **** Example: bio 18090102 18631117
      **** Will display the three cycles:
      **** Physcial 23 days, Emotional 28 days, Mental 33 days
      **** for that date.
      ****
      *************************************************************
       configuration section.
       source-computer.
           System76
      *           with debugging mode
           .
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 w-d1                                              pic x(08).
       01 w-d2                                              pic x(08).
       01 n-d1                                              pic 9(08).
       01 n-d2                                              pic 9(08).
       01 w-i1                                       comp-x pic x(04).
       01 w-i2                                       comp-x pic x(04).
       01 w-days                                            pic 9(07).
       01 arg-knt                                    comp-5 pic x(01).
       01 bx                                       pic 9.
       01 bio-tbl  value 'Physical 23Emotional28Mental   33'.
               05  bio-entry  occurs 3 times.
                   10  bio-cyc                     pic x(09).
                   10  bio-lth                     pic 9(02).
       01 bio-data occurs 3 times.
          05  bio-mod                              pic 9(02).
          05  bio-sin                              pic s999v9.
          05  bio-dsc                              pic x(09).

       procedure division.
           accept arg-knt from argument-number
           if arg-knt <> 2
           then
            display 'two arguments are required:' upon SYSERR
            display ' 1. first  date ccyymmdd'    upon SYSERR
            display ' 2. second date ccyymmdd'    upon SYSERR
            stop run returning -1
           end-if
           accept w-d1 from argument-value
           if  w-d1 not numeric
               display ' first date not numeric ' upon syserr
               move 2 to return-code
               stop run
           end-if
           move w-d1 to n-d1
           if  (n-d1 > 99991231)
               display ' first date must be less than 99991232'
                       upon syserr
               move 3 to return-code
               stop run
           end-if
           if  (n-d1 < 16010101)
               display ' first date must be greater than 16010100'
                       upon syserr
               move 4 to return-code
               stop run
           end-if
           if  ((n-d1(5:2) = '00')
               or
                (n-d1(5:2) > '12'))
               display ' invalid month for first date ' upon syserr
               move 5 to return-code
               stop run
           end-if
           if  ((n-d1(7:2) = '00')
               or
                (n-d1(7:2) > '31'))
               display ' invalid day for first date ' upon syserr
               move 6 to return-code
               stop run
           end-if
           accept w-d2 from argument-value
           if  w-d2 not numeric
               display 'second date not numeric ' upon syserr
               move 12 to return-code
               stop run
           end-if
           move w-d2 to n-d2
           if  (n-d2 > 99991231)
               display ' second date must be less than 99991232'
                       upon syserr
               move 13 to return-code
               stop run
           end-if
           if  (n-d2 < 16010101)
               display ' second date must be greater than 16010100'
                       upon syserr
               move 14 to return-code
               stop run
           end-if
           if  ((n-d2(5:2) = '00')
               or
                (n-d2(5:2) > '12'))
               display ' invalid month for second date ' upon syserr
               move 15 to return-code
               stop run
           end-if
           if  ((n-d2(7:2) = '00')
               or
                (n-d2(7:2) > '31'))
               display ' invalid day for second date ' upon syserr
               move 16 to return-code
               stop run
           end-if
           move w-d1 to n-d1
           move w-d2 to n-d2
           move integer-of-date(n-d1) to w-i1
           move integer-of-date(n-d2) to w-i2
           compute w-days = w-i1 - w-i2
           display w-days
           perform  varying  bx from 1 by 1 until bx greater than 3
               move mod(w-days, bio-lth(bx)) to bio-mod(bx)
               compute bio-sin(bx) rounded
                  = 100 * sin(2 * PI * bio-mod(bx) / bio-lth(bx))
               end-compute
               display bio-cyc(bx) " "
                       bio-mod(bx) ":"
                       bio-sin(bx) "%" with no advancing
               end-display
               if  bio-sin(bx) > 95
                   move  " peak" to bio-dsc(bx)
               end-if
               if  bio-sin(bx) < -95
                   move  " valley" to bio-dsc(bx)
               end-if
               if  abs(bio-sin(bx)) < 5
                   move " critical" to bio-dsc(bx)
               end-if
               display bio-dsc(bx)
           end-perform
           move 0 to return-code
           goback
           .
