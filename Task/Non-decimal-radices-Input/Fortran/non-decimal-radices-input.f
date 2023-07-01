program Example
  implicit none

  integer :: num
  character(32) :: str

  str = "0123459"
  read(str, "(i10)") num   ! Decimal
  write(*,*) num           ! Prints 123459

  str = "abcf123"
  read(str, "(z8)") num    ! Hexadecimal
  write(*,*) num           ! Prints 180154659

  str = "7651"
  read(str, "(o11)") num   ! Octal
  write(*,*) num           ! Prints 4009

  str = "1010011010"
  read(str, "(b32)") num   ! Binary
  write(*,*) num           ! Prints 666

end program
