       program nivengaps
       implicit none
       integer*8 prev /1/, gap /0/, sum /0/
       integer*8 nividx /0/, niven /1/
       integer gapidx /1/

       character*13 idxfmt
       character*14 nivfmt
       write (*,*) 'Gap no  Gap   Niven index    Niven number '
       write (*,*) '------  ---  -------------  --------------'

 10    call divsum(niven, sum)
       if (mod(niven, sum) .EQ. 0) then
          if (niven .GT. prev + gap) then
             gap = niven - prev
             call fmtint(nividx,13,idxfmt)
             call fmtint(prev,14,nivfmt)
             write (*,20) gapidx,gap,idxfmt,nivfmt
             gapidx = gapidx + 1
          end if
          prev = niven
          nividx = nividx + 1
       end if
       niven = niven + 1
       if (gapidx .LE. 32) go to 10

       stop
 20    format (i7,'  ',i3,'  ',a13,'  ',a14)
       end program

C      Sum of divisors of NN, given the sum of divisors of NN-1
       subroutine divsum(nn,sum)
          implicit none
          integer*8 n,nn,sum
          n = nn
          sum = sum + 1
 30       if (n.GT.0 .AND. mod(n,10).EQ.0) then
             sum = sum - 9
             n = n / 10
             go to 30
          end if
       end subroutine

       integer*8 function mod(a,b)
          implicit none
          integer*8 a,b
          mod = a - a/b * b
       end function

C      Format a positive integer with ',' as the thousands separator.
       subroutine fmtint(num, len, str)
          implicit none
          integer*8 n, num
          integer pos, len, th
          character(*) str
          n=num
          pos=len
          th=2
 40       if (pos.GT.0) then
             if (n.EQ.0) then
                str(pos:pos) = ' '
             else
                str(pos:pos) = achar(mod(n,10) + iachar('0'))
                if (th.EQ.0 .AND. n.GE.10 .AND. pos.GT.1) then
                    th = 2
                    pos = pos-1
                    str(pos:pos) = ','
                else
                    th = th-1
                end if
            end if
            pos = pos - 1
            n = n/10
            go to 40
          end if
       end subroutine
