!-----------------------------------------------------------------------
! Test Linux urandom in Fortran
!-----------------------------------------------------------------------
program    urandom_test
  use iso_c_binding, only : c_long
  implicit none

  character(len=*), parameter :: RANDOM_PATH = "/dev/urandom"
  integer :: funit, ios
  integer(c_long) :: buf

  open(newunit=funit, file=RANDOM_PATH, access="stream", form="UNFORMATTED", &
       iostat=ios, status="old", action="read")
  if ( ios /= 0 ) stop "Error opening file: "//RANDOM_PATH

  read(funit) buf

  close(funit)

  write(*,'(A,I64)') "Integer:     ", buf
  write(*,'(A,B64)') "Binary:      ", buf
  write(*,'(A,Z64)') "Hexadecimal: ", buf

end program urandom_test
