program DataEncryptionStandard
! This uses the DES library "Frypto" by Fran Martinez Fadrique
! the Github link is https://github.com/ffadrique/Frypto
! he has released the FORTRAN code under LGPL-2.1 license
    use m_des
    use, intrinsic :: iso_fortran_env, only: int8
    implicit none

    ! DES context type
    type(t_des) :: cipher

    ! Data buffers
    integer(int8) :: plain(16) = [int(z'87',int8), int(z'87',int8), int(z'87',int8), int(z'87',int8), &
                                  int(z'87',int8), int(z'87',int8), int(z'87',int8), int(z'87',int8), &
                                  int(z'08',int8), int(z'08',int8), int(z'08',int8), int(z'08',int8), &
                                  int(z'08',int8), int(z'08',int8), int(z'08',int8), int(z'08',int8)]
    integer(int8) :: encrypt(16), decrypt(16)

    ! Encryption key
    integer(int8) :: key(8) = [int(z'0E',int8), int(z'32',int8), int(z'92',int8), int(z'32',int8), &
                               int(z'EA',int8), int(z'6D',int8), int(z'0D',int8), int(z'73',int8)]

    ! Initialize DES context with key
    cipher = des(key)

    ! Print original plaintext (first block)
    write(*,'(A)',advance='no') "plain:   "
    call PrintHexBytes(plain(1:8), 8)

    ! Encrypt in 8-byte blocks (ECB mode)
    call cipher%encrypt(plain(1:8), encrypt(1:8))   ! First block
    call cipher%encrypt(plain(9:16), encrypt(9:16)) ! Second block

    write(*,'(A)',advance='no') "encrypt: "
    call PrintHexBytes(encrypt, 16)

    ! Decrypt in 8-byte blocks
    call cipher%decrypt(encrypt(1:8), decrypt(1:8))   ! First block
    call cipher%decrypt(encrypt(9:16), decrypt(9:16)) ! Second block

    write(*,'(A)',advance='no') "plain:   "
    call PrintHexBytes(decrypt(1:8), 8)

contains

    ! Hexadecimal output routine
    subroutine PrintHexBytes(data, limit)
        integer(int8), intent(in) :: data(:)
        integer, intent(in) :: limit
        character(len=2) :: hex
        integer :: i

        do i = 1, min(limit, size(data))
            write(hex,'(Z2.2)') data(i)
            write(*,'(A)',advance='no') trim(hex)
        end do
        print *
    end subroutine PrintHexBytes

end program DataEncryptionStandard


