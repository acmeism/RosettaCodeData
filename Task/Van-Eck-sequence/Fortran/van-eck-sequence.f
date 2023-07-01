      program VanEck
      implicit none
      integer eck(1000), i, j

      eck(1) = 0
      do 20 i=1, 999
          do 10 j=i-1, 1, -1
              if (eck(i) .eq. eck(j)) then
                  eck(i+1) = i-j
                  go to 20
              end if
 10       continue
          eck(i+1) = 0
 20   continue

      do 30 i=1, 10
 30       write (*,'(I4)',advance='no') eck(i)
      write (*,*)

      do 40 i=991, 1000
 40       write (*,'(I4)',advance='no') eck(i)
      write (*,*)

      end program
