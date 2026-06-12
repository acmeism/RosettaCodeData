       program divprod
       implicit none
       integer divis(50), i, j
       do 10 i=1, 50
 10        divis(i) = 1
       do 20 i=2, 50
           do 20 j=i, 50, i
 20            divis(j) = divis(j)*i
       do 30 i=1, 50
           write (*,'(I10)',advance='no') divis(i)
 30        if (i/5 .ne. (i-1)/5) write (*,*)
       end program
