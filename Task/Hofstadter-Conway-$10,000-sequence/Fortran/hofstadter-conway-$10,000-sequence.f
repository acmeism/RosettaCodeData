program conway
  implicit none
  integer :: a(2**20)  ! The sequence a(n)
  real    :: b(2**20)  ! The sequence a(n)/n
  real    :: v         ! Max value in the range [2*i, 2**(i+1)]
  integer :: nl(1)     ! The location of v in the array b(n)
  integer :: i, N, first, second, last, m

  ! Populate a(n) and b(n)
  a(1:2) = [1, 1]
  b(1:2) = [1.0e0, 0.5e0]
  N = 2
  do i=1,2**20
     last = a(N)
     first = a(last)
     second = a(N-last+1)
     N = N+1
     a(N:N) = first + second
     b(N:N) = a(N:N)/real(N)
  end do

  ! Calculate the max values in the logarithmic ranges
  m = 0
  do i=1,19
     v = maxval(b(2**i:2**(i+1)))
     nl = maxloc(b(2**i:2**(i+1)))
     write(*,'(2(a,i0),a,f8.6,a,i0)') &
          'Max. between 2**', i,      &
          ' and 2**', (i+1),          &
          ' is ', v,                  &
          ' at n = ', 2**i+nl(1)-1
     if (m == 0 .and. v < 0.55e0) then
        m = i-1
     end if
  end do

  ! Calculate Mallows number
  do i=2**(m+1), 2**m,-1
     if (b(i) > 0.55e0) then
        exit
     end if
  end do
  write(*,'(a,i0)') 'Mallows number = ',i

end program conway
