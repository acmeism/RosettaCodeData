/*REXX program to  rescale a  (decimal fraction)  price (0.99 ──► 1.00).*/
pad='     '                            /*for inserting spaces into msg. */
      do j=0  to 1  by .01;        if j==0 then j=0.00   /*special case.*/
      say pad 'original price ──►' j pad adjPrice(j) " ◄── adjusted price"
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ADJPRICE subroutine─────────────────*/
adjPrice:  procedure;   parse arg ?
                select
                when ?<0.06  then ?=0.10
                when ?<0.11  then ?=0.18
                when ?<0.16  then ?=0.26
                when ?<0.21  then ?=0.32
                when ?<0.26  then ?=0.38
                when ?<0.31  then ?=0.44
                when ?<0.36  then ?=0.50
                when ?<0.41  then ?=0.54
                when ?<0.46  then ?=0.58
                when ?<0.51  then ?=0.62
                when ?<0.56  then ?=0.66
                when ?<0.61  then ?=0.70
                when ?<0.66  then ?=0.74
                when ?<0.71  then ?=0.78
                when ?<0.76  then ?=0.82
                when ?<0.81  then ?=0.86
                when ?<0.86  then ?=0.90
                when ?<0.91  then ?=0.94
                when ?<0.96  then ?=0.98
                when ?<1.01  then ?=1.00
                otherwise    nop
                end   /*select*/
return ?
