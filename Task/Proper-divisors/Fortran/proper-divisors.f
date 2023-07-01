      function icntprop(num  )
      icnt=0
      do i=1 , num-1
          if (mod(num , i)  .eq. 0)  then
          icnt = icnt + 1
          if (num .lt. 11) print *,'    ',i
          end if
          end do
      icntprop =  icnt
      end function

      limit = 20000
      maxcnt = 0
      print *,'N   divisors'
      do j=1,limit,1
      if (j .lt. 11) print *,j
      icnt = icntprop(j)

      if (icnt .gt. maxcnt) then
      maxcnt = icnt
      maxj = j
      end if

      end do

      print *,' '
      print *,' from 1 to ',limit
      print *,maxj,' has max proper divisors: ',maxcnt
      end
