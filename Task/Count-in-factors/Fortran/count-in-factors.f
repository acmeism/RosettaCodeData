!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Thu Jun  6 23:29:06
!
!a=./f && make $a && echo -2 | OMP_NUM_THREADS=2 $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
! assert           1 = */           1
! assert           2 = */           2
! assert           3 = */           3
! assert           4 = */           2           2
! assert           5 = */           5
! assert           6 = */           2           3
! assert           7 = */           7
! assert           8 = */           2           2           2
! assert           9 = */           3           3
! assert          10 = */           2           5
! assert          11 = */          11
! assert          12 = */           3           2           2
! assert          13 = */          13
! assert          14 = */           2           7
! assert          15 = */           3           5
! assert          16 = */           2           2           2           2
! assert          17 = */          17
! assert          18 = */           3           2           3
! assert          19 = */          19
! assert          20 = */           2           2           5
! assert          21 = */           3           7
! assert          22 = */           2          11
! assert          23 = */          23
! assert          24 = */           3           2           2           2
! assert          25 = */           5           5
! assert          26 = */           2          13
! assert          27 = */           3           3           3
! assert          28 = */           2           2           7
! assert          29 = */          29
! assert          30 = */           5           2           3
! assert          31 = */          31
! assert          32 = */           2           2           2           2           2
! assert          33 = */           3          11
! assert          34 = */           2          17
! assert          35 = */           5           7
! assert          36 = */           3           3           2           2
! assert          37 = */          37
! assert          38 = */           2          19
! assert          39 = */           3          13
! assert          40 = */           5           2           2           2

module prime_mod

  ! sieve_table stores 0 in prime numbers, and a prime factor in composites.
  integer, dimension(:), allocatable :: sieve_table
  private :: PrimeQ

contains

  ! setup routine must be called first!
  subroutine sieve(n) ! populate sieve_table.  If n is 0 it deallocates storage, invalidating sieve_table.
    integer, intent(in) :: n
    integer :: status, i, j
    if ((n .lt. 1) .or. allocated(sieve_table)) deallocate(sieve_table)
    if (n .lt. 1) return
    allocate(sieve_table(n), stat=status)
    if (status .ne. 0) stop 'cannot allocate space'
    sieve_table(1) = 1
    do i=2,int(sqrt(real(n)))+1
       if (sieve_table(i) .eq. 0) then
          do j = i*i, n, i
             sieve_table(j) = i
          end do
       end if
    end do
  end subroutine sieve

  subroutine check_sieve(n)
    integer, intent(in) :: n
    if (.not. (allocated(sieve_table) .and. ((1 .le. n) .and. (n .le. size(sieve_table))))) stop 'Call sieve first'
  end subroutine check_sieve

  logical function isPrime(p)
    integer, intent(in) :: p
    call check_sieve(p)
    isPrime = PrimeQ(p)
  end function isPrime

  logical function isComposite(p)
    integer, intent(in) :: p
    isComposite = .not. isPrime(p)
  end function isComposite

  logical function PrimeQ(p)
    integer, intent(in) :: p
    PrimeQ = sieve_table(p) .eq. 0
  end function PrimeQ

  subroutine prime_factors(p, rv, n)
    integer, intent(in) :: p ! number to factor
    integer, dimension(:), intent(out) :: rv ! the prime factors
    integer, intent(out) :: n ! number of factors returned
    integer :: i, m
    call check_sieve(p)
    m = p
    i = 1
    if (p .ne. 1) then
       do while ((.not. PrimeQ(m)) .and. (i .lt. size(rv)))
          rv(i) = sieve_table(m)
          m = m/rv(i)
          i = i+1
       end do
    end if
    if (i .le. size(rv)) rv(i) = m
    n = i
  end subroutine prime_factors

end module prime_mod

program count_in_factors
  use prime_mod
  integer :: i, n
  integer, dimension(8) :: factors
  call sieve(40)                ! setup
  do i=1,40
     factors = 0
     call prime_factors(i, factors, n)
     write(6,*)'assert',i,'= */',factors(:n)
  end do
  call sieve(0)                 ! release memory
end program count_in_factors
