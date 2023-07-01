program substitution
  implicit none

  integer, parameter :: len_max = 256
  integer, parameter :: eof = -1
  integer :: in_unit = 9, out_unit = 10, ios
  character(len_max) :: line

  open(in_unit, file="plain.txt",  iostat=ios)
  if (ios /= 0) then
    write(*,*) "Error opening plain.txt file"
    stop
  end if

  open(out_unit, file="encrypted.txt", iostat=ios)
  if (ios /= 0) then
    write(*,*) "Error opening encrypted.txt file"
    stop
  end if

! Encryption
  do
    read(in_unit, "(a)", iostat=ios) line
    if (ios > 0) then
      write(*,*) "Error reading plain.txt file"
      stop
    else if (ios == eof) then
      exit
    end if

    call cipher(trim(line))
    write(out_unit, "(a)", iostat=ios) trim(line)
    if (ios /= 0) then
      write(*,*) "Error writing encrypted.txt file"
      stop
    end if
  end do

  close(in_unit)
  close(out_unit)

  open(in_unit, file="encrypted.txt",  iostat=ios)
  if (ios /= 0) then
    write(*,*) "Error opening encrypted.txt file"
    stop
  end if

  open(out_unit, file="decrypted.txt", iostat=ios)
  if (ios /= 0) then
    write(*,*) "Error opening decrypted.txt file"
    stop
  end if

! Decryption
  do
    read(in_unit, "(a)", iostat=ios) line
    if (ios > 0) then
      write(*,*) "Error reading encrypted.txt file"
      stop
    else if (ios == eof) then
      exit
    end if

    call cipher(trim(line))
    write(out_unit, "(a)", iostat=ios) trim(line)
    if (ios /= 0) then
      write(*,*) "Error writing decrypted.txt file"
      stop
    end if
  end do

  close(in_unit)
  close(out_unit)

contains

subroutine cipher(text)
  character(*), intent(in out) :: text
  integer :: i

! Substitutes A -> Z, B -> Y ... Y -> B, Z -> A and ditto for lower case
! works for both encryption and decryption

  do i = 1, len(text)
    select case(text(i:i))
      case ('A':'Z')
        text(i:i) = achar(155 - iachar(text(i:i)))
      case ('a':'z')
        text(i:i) = achar(219 - iachar(text(i:i)))
    end select
  end do
end subroutine

end program
