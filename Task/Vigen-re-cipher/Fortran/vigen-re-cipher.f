program vigenere_cipher
  implicit none

  character(80) :: plaintext = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!", &
                   ciphertext = ""
  character(14) :: key = "VIGENERECIPHER"


  call encrypt(plaintext, ciphertext, key)
  write(*,*) plaintext
  write(*,*) ciphertext
  call decrypt(ciphertext, plaintext, key)
  write(*,*) plaintext

contains

subroutine encrypt(intxt, outtxt, k)
  character(*), intent(in)  :: intxt, k
  character(*), intent(out) :: outtxt
  integer :: chrn
  integer :: cp = 1, kp = 1
  integer :: i

  outtxt = ""
  do i = 1, len(trim(intxt))
    select case(intxt(i:i))
      case ("A":"Z", "a":"z")
        select case(intxt(i:i))
          case("a":"z")
            chrn = iachar(intxt(i:i)) - 32

          case default
            chrn = iachar(intxt(i:i))

        end select

        outtxt(cp:cp) = achar(modulo(chrn + iachar(k(kp:kp)), 26) + 65)
        cp = cp + 1
        kp = kp + 1
        if(kp > len(k)) kp = kp - len(k)

    end select
  end do
end subroutine

subroutine decrypt(intxt, outtxt, k)
  character(*), intent(in)  :: intxt, k
  character(*), intent(out) :: outtxt
  integer :: chrn
  integer :: cp = 1, kp = 1
  integer :: i

  outtxt = ""
  do i = 1, len(trim(intxt))
    chrn = iachar(intxt(i:i))
    outtxt(cp:cp) = achar(modulo(chrn - iachar(k(kp:kp)), 26) + 65)
    cp = cp + 1
    kp = kp + 1
    if(kp > len(k)) kp = kp - len(k)
   end do
end subroutine
end program
