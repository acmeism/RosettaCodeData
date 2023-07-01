program Normal_Distribution
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer, parameter :: r64 = selected_real_kind(15)
  integer(i64), parameter :: samples = 1000000_i64
  real(r64) :: mean, stddev
  real(r64) :: sumn = 0, sumnsq = 0
  integer(i64) :: n = 0
  integer(i64) :: bin(-50:50) = 0
  integer :: i, ind
  real(r64) :: ur1, ur2, nr1, nr2, s

  n = 0
  do while(n <= samples)
    call random_number(ur1)
    call random_number(ur2)
    ur1 = ur1 * 2.0 - 1.0
    ur2 = ur2 * 2.0 - 1.0

    s = ur1*ur1 + ur2*ur2
    if(s >= 1.0_r64) cycle

    nr1 = ur1 * sqrt(-2.0*log(s)/s)
    ind = floor(5.0*nr1)
    bin(ind) = bin(ind) + 1_i64
    sumn = sumn + nr1
    sumnsq = sumnsq + nr1*nr1

    nr2 = ur2 * sqrt(-2.0*log(s)/s)
    ind = floor(5.0*nr2)
    bin(ind) = bin(ind) + 1_i64
    sumn = sumn + nr2
    sumnsq = sumnsq + nr2*nr2
    n = n + 2_i64
  end do

  mean = sumn / n
  stddev = sqrt(sumnsq/n - mean*mean)

  write(*, "(a, i0)") "sample size = ", samples
  write(*, "(a, f17.15)") "Mean :   ", mean,
  write(*, "(a, f17.15)") "Stddev : ", stddev

  do i = -15, 15
    write(*, "(f4.1, a, a)") real(i)/5.0, ": ", repeat("=", int(bin(i)*500/samples))
  end do

end program
