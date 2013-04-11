program NthRootTest
  implicit none

  print *, nthroot(10, 7131.5**10)
  print *, nthroot(5, 34.0)

contains

  function nthroot(n, A, p)
    real :: nthroot
    integer, intent(in)        :: n
    real, intent(in)           :: A
    real, intent(in), optional :: p

    real :: rp, x(2)

    if ( A < 0 ) then
       stop "A < 0"       ! we handle only real positive numbers
    elseif ( A == 0 ) then
       nthroot = 0
       return
    end if

    if ( present(p) ) then
       rp = p
    else
       rp = 0.001
    end if

    x(1) = A
    x(2) = A/n   ! starting "guessed" value...

    do while ( abs(x(2) - x(1)) > rp )
       x(1) = x(2)
       x(2) = ((n-1.0)*x(2) + A/(x(2) ** (n-1.0)))/real(n)
    end do

    nthroot = x(2)

  end function nthroot

end program NthRootTest
