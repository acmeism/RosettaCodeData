       identification division.
       program-id. hailstones.
       remarks. cobc -x hailstones.cob.

       data division.
       working-storage section.
       01 most                 constant as 1000000.
       01 coverage             constant as 100000.
       01 stones               usage binary-long.
       01 n                    usage binary-long.
       01 storm                usage binary-long.

       01 show-arg             pic 9(6).
       01 show-default         pic 99 value 27.
       01 show-sequence        usage binary-long.
       01 longest              usage binary-long occurs 2 times.

       01 filler.
          05 hail              usage binary-long
                               occurs 0 to most depending on stones.
       01 show                 pic z(10).
       01 low-range            usage binary-long.
       01 high-range           usage binary-long.
       01 range                usage binary-long.


       01 remain               usage binary-long.
       01 unused               usage binary-long.

       procedure division.
       accept show-arg from command-line
       if show-arg less than 1 or greater than coverage then
           move show-default to show-arg
       end-if
       move show-arg to show-sequence

       move 1 to longest(1)
       perform hailstone varying storm
                         from 1 by 1 until storm > coverage
       display "Longest at: " longest(2) " with " longest(1) " elements"
       goback.

      *> **************************************************************
       hailstone.
       move 0 to stones
       move storm to n
       perform until n equal 1
           if stones > most then
               display "too many hailstones" upon syserr
               stop run
           end-if

           add 1 to stones
           move n to hail(stones)
           divide n by 2 giving unused remainder remain
           if remain equal 0 then
               divide 2 into n
           else
               compute n = 3 * n + 1
           end-if
       end-perform
       add 1 to stones
       move n to hail(stones)

       if stones > longest(1) then
           move stones to longest(1)
           move storm to longest(2)
       end-if

       if storm equal show-sequence then
           display show-sequence ": " with no advancing
           perform varying range from 1 by 1 until range > stones
               move 5 to low-range
               compute high-range = stones - 4
               if range < low-range or range > high-range then
                   move hail(range) to show
                   display function trim(show) with no advancing
                   if range < stones then
                       display ", " with no advancing
                   end-if
               end-if
               if range = low-range and stones > 8 then
                   display "..., " with no advancing
               end-if
           end-perform
           display ": " stones " elements"
       end-if
       .

       end program hailstones.
