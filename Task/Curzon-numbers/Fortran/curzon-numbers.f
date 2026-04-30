!
! Curzon Numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., September 2025
!
program Curzon

  implicit none

  integer, parameter  :: kint = 8   ! 8-byte-integers are big enough, 4 bytes is insufficient.

  integer (kind=kint) :: base, num, count

  do base=2,10,2
    print ("( 'Curzon numbers with base ', i2,':')"),  base
    count = 0
    num = 1
    do while (count .lt. 50)
      if (isCurzon (num, base)) then
        count = count + 1
        write (*, '(i5)', advance='no') num
        if (mod (count, 10) .eq. 0 ) write (*,*)      ! EOL
      end if
      num = num + 1
    end do
    do
      if (isCurzon (num,base)) then
        count = count + 1
        if (count .eq. 1000) exit
      endif
      num = num + 1
    end do
    print ("('1000th Curzon number with base ', i0, ': ', i0/)") , base,  num

  end do

  contains


  function isCurzon (n, k) result (YN)

  integer(kind=kint), intent(in) :: n,k
  integer(kind=kint) :: m, p
  logical :: YN

  m = k*n+1
  p = ModularExp (k,n,m) + 1
  YN = m .eq. p

  end function isCurzon

  function ModularExp(a, b, n)  result(d)

  integer(kind=kint) , intent(in) :: a,b,n
  integer (kind=kint) :: d
  integer (kind=kint) :: i, k
  d = 1
  k = 0
  do while (ishft (b, -k) .gt. 0)
    k = k + 1
  end do
  do i = k - 1, 0, -1
    d = mod (d*d, n)
    if (iand (ishft (b, -i) , 1_kint) .gt. 0) d = mod (d*a ,n);
  end do

  end function ModularExp

end program Curzon
