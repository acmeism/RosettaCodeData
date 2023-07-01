program isin
    use ctype
    implicit none
    character(20) :: test(7) = ["US0378331005        ", &
                                "US0373831005        ", &
                                "U50378331005        ", &
                                "US03378331005       ", &
                                "AU0000XVGZA3        ", &
                                "AU0000VXGZA3        ", &
                                "FR0000988040        "]
    print *, check_isin(test)
contains
    elemental logical function check_isin(a)
        character(*), intent(in) :: a
        integer :: s(24)
        integer :: i, j, k, n, v

        check_isin = .false.

        n = len_trim(a)
        if (n /= 12) return

        ! Convert to an array of digits
        j = 0
        do i = 1, n
            k = iachar(a(i:i))
            if (k >= 48 .and. k <= 57) then
                if (i < 3) return
                k = k - 48
                j = j + 1
                s(j) = k
            else if (k >= 65 .and. k <= 90) then
                if (i == 12) return
                k = k - 65 + 10
                j = j + 1
                s(j) = k / 10
                j = j + 1
                s(j) = mod(k, 10)
            else
                return
            end if
        end do

        ! Compute checksum
        v = 0
        do i = j - 1, 1, -2
            k = 2 * s(i)
            if (k > 9) k = k - 9
            v = v + k
        end do
        do i = j, 1, -2
            v = v + s(i)
        end do

        check_isin = 0 == mod(v, 10)
    end function
end program
