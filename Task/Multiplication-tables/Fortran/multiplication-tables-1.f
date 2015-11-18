program multtable
implicit none

  integer :: i, j, k

    write(*, "(a)") " x|   1   2   3   4   5   6   7   8   9  10  11  12"
    write(*, "(a)") "--+------------------------------------------------"
    do i = 1, 12
      write(*, "(i2, a)", advance="no") i, "|"
	do k = 2, i
    	  write(*, "(a4)", advance="no") ""
        end do
    	do j = i, 12
          write(*, "(i4)", advance="no") i*j
        end do
        write(*, *)
    end do

end program multtable
