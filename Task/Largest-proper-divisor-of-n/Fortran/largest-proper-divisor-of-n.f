       program LargestProperDivisors
       implicit none
       integer i, lpd
       do 10 i=1, 100
           write (*,'(I3)',advance='no') lpd(i)
 10        if (i/10*10 .eq. i) write (*,*)
       end program

       integer function lpd(n)
       implicit none
       integer n, i
       if (n .le. 1) then
           lpd = 1
       else
           do 10 i=n-1, 1, -1
 10            if (n/i*i .eq. n) goto 20
 20        lpd = i
       end if
       end function
