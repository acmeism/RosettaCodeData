program main
  !=======================================================================================
  implicit none

  !=== Local data
  integer                      :: n

  !=== External procedures
  double precision, external   :: catalan_numbers

  !=== Execution =========================================================================

  write(*,'(1x,a)')'==============='
  write(*,'(5x,a,6x,a)')'n','c(n)'
  write(*,'(1x,a)')'---------------'

  do n = 0, 14
    write(*,'(1x,i5,i10)') n, int(catalan_numbers(n))
  enddo

  write(*,'(1x,a)')'==============='

  !=======================================================================================
end program main
!BL
!BL
!BL
double precision recursive function catalan_numbers(n) result(value)
  !=======================================================================================
  implicit none

  !=== Input, ouput data
  integer, intent(in)          :: n

  !=== Execution =========================================================================

  if ( n .eq. 0 ) then
    value = 1
  else
    value = ( 2.0d0 * dfloat(2 * n - 1) / dfloat( n + 1 ) ) * catalan_numbers(n-1)
  endif

  !=======================================================================================
end function catalan_numbers
