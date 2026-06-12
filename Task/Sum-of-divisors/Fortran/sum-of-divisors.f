       program DivSum
       implicit none
       integer i, j, col, divs(100)

       do 10 i=1, 100, 1
 10        divs(i) = 1

       do 20 i=2, 100, 1
           do 20 j=i, 100, i
 20            divs(j) = divs(j) + i

       col = 0
       do 30 i=1, 100, 1
           write (*,'(I4)',advance='no') divs(i)
           col = col + 1
           if (col .eq. 10) then
               col = 0
               write (*,*)
           end if
 30    continue
       end program
