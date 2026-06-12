program shift_array
    implicit none
    integer, dimension(9) :: shift = (/1, 2, 3, 4, 5, 6, 7, 8, 9/)
    !
    ! Print original array
    print *, 'Original array:'
    print '(9I3)', shift

    ! Perform left shift using cshift
    shift = cshift(shift, 3)


    ! Print shifted array
    print *, 'Shifted array (left by 3):'
    print '(9I3)', shift

end program shift_array
