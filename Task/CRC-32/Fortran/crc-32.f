module crc32_m
    use iso_fortran_env
    implicit none
    integer(int32) :: crc_table(0:255)
contains
    subroutine update_crc(a, crc)
        integer :: n, i
        character(*) :: a
        integer(int32) :: crc

        crc = not(crc)
        n = len(a)
        do i = 1, n
            crc = ieor(shiftr(crc, 8), crc_table(iand(ieor(crc, iachar(a(i:i))), 255)))
        end do
        crc = not(crc)
    end subroutine

    subroutine init_table
        integer :: i, j
        integer(int32) :: k

        do i = 0, 255
            k = i
            do j = 1, 8
                if (btest(k, 0)) then
                    k = ieor(shiftr(k, 1), -306674912)
                else
                    k = shiftr(k, 1)
                end if
            end do
            crc_table(i) = k
        end do
    end subroutine
end module

program crc32
    use crc32_m
    implicit none
    integer(int32) :: crc = 0
    character(*), parameter :: s = "The quick brown fox jumps over the lazy dog"
    call init_table
    call update_crc(s, crc)
    print "(Z8)", crc
end program
