!
! Square but not cube
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! Original C code converted to Fortran
! U.B., December 2025
!==============================================================================
program SquareNotCube

implicit none

integer :: n=0                                            ! base number to square
integer ::  square                                        ! The base number squared
integer ::  cubicRoot                                     ! Int of 3rd root of square
integer :: count=0                                        ! counts squares that are not cubes

do while (count .lt. 30)                                  ! Loop until 30 squares but not cubes found
  n = n + 1
  square = n*n
  cubicRoot =  int (square ** (1./3.))                    ! is ok here because square is always positive.
  if (cubicRoot*cubicRoot*cubicRoot .ne. square) then     ! Square is not cubic number
    count = count + 1
    write (*, '(I4)')  square
  else                                                    ! square is also cubic number
    write (*, '(I4, " is square and cube." )')   square
  end if
end do

end program SquareNotCube
