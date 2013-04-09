program Caesar_Cipher
  implicit none

  integer, parameter :: key = 3
  character(43) :: message = "The five boxing wizards jump quickly"

  write(*, "(2a)") "Original message  = ", message
  call encrypt(message)
  write(*, "(2a)") "Encrypted message = ", message
  call decrypt(message)
  write(*, "(2a)") "Decrypted message = ", message

contains

subroutine encrypt(text)
  character(*), intent(inout) :: text
  integer :: i

  do i = 1, len(text)
    select case(text(i:i))
      case ('A':'Z')
        text(i:i) = achar(modulo(iachar(text(i:i)) - 65 + key, 26) + 65)
      case ('a':'z')
        text(i:i) = achar(modulo(iachar(text(i:i)) - 97 + key, 26) + 97)
    end select
  end do
end subroutine

subroutine decrypt(text)
  character(*), intent(inout) :: text
  integer :: i

  do i = 1, len(text)
    select case(text(i:i))
      case ('A':'Z')
        text(i:i) = achar(modulo(iachar(text(i:i)) - 65 - key, 26) + 65)
      case ('a':'z')
        text(i:i) = achar(modulo(iachar(text(i:i)) - 97 - key, 26) + 97)
    end select
  end do
end subroutine

end program Caesar_Cipher
