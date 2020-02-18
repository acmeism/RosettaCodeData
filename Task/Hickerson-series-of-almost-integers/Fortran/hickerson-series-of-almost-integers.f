program hickerson
    implicit none
    integer, parameter :: q = selected_real_kind(30)
    integer, parameter :: l = selected_int_kind(15)
    real(q) :: s, l2
    integer :: i, n, k

    l2 = log(2.0_q)
    do n = 1, 17
        s = 0.5_q / l2
        do i = 1, n
            s = (s * i) / l2
        end do

        k = floor((s - floor(s, l)) * 10)
        if (k == 0 .or. k == 9) then
            print 1, n, s, ""
        else
            print 1, n, s, " NOT"
        endif
    end do
  1 format('h(',I2,') = ',F23.3,' is',A,' an almost-integer')
end program
