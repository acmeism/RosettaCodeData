program basic_stats
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer, parameter :: r64 = selected_real_kind(15)
  integer(i64), parameter :: samples = 1000000000_i64

  real(r64) :: r
  real(r64) :: mean, stddev
  real(r64) :: sumn = 0, sumnsq = 0
  integer(i64) :: n = 0
  integer(i64) :: bin(10) = 0
  integer :: i, ind

  call random_seed

  n = 0
  do while(n <= samples)
    call random_number(r)
    ind = r * 10 + 1
    bin(ind) = bin(ind) + 1_i64
    sumn = sumn + r
    sumnsq = sumnsq + r*r
    n = n + 1_i64
  end do

  mean = sumn / n
  stddev = sqrt(sumnsq/n - mean*mean)
  write(*, "(a, i0)") "sample size = ", samples
  write(*, "(a, f17.15)") "Mean :   ", mean,
  write(*, "(a, f17.15)") "Stddev : ", stddev
  do i = 1, 10
    write(*, "(f3.1, a, a)") real(i)/10.0, ": ", repeat("=", int(bin(i)*500/samples))
  end do

end program
