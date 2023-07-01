program sieve_wheel_2

  implicit none
  integer, parameter :: i_max = 10000000
  integer, parameter :: i_range = (i_max - 3) / 2
  integer :: i, j, k, cnt
  byte, dimension (0:i_range / 8) :: composites

  composites = 0 ! pre-initialized?
  do i = 0, (int (sqrt (real (i_max))) - 3) / 2
    if (iand(composites(shiftr(i, 3)), shiftl(1, iand(i, 7))) == 0) then
      do j = (i + i) * (i + 3) + 3, i_range, i + i + 3
        k = shiftr(j, 3)
        composites(k) = ior(composites(k), shiftl(1, iand(j, 7)))
      end do
    end if
  end do
!  write (*, '(i0, 1x)', advance = 'no') 2
  cnt = 1
  do i = 0, i_range
    if (iand(composites(shiftr(i, 3)), shiftl(1, iand(i, 7))) == 0) then
!      write (*, '(i0, 1x)', advance = 'no') (i + i + 3)
      cnt = cnt + 1
    end if
  end do
!  write (*, *)
  print '(a, i0, a, i0, a, f0.0, a)', &
        'There are ', cnt, ' primes up to ', i_max, '.'
end program sieve_wheel_2
