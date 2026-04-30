! Wilson's theorem: p is prime iff p divides (p-1)! + 1
! Factorial is computed mod p to avoid overflow.
program primality
  implicit none
  integer :: n

  write(*,'(A)') 'Primality test via Wilson''s theorem'
  write(*,'(A)') '------------------------------------'
  write(*,'(A)') 'Non-positive and 1:'
  do n = -2, 1
    call report(n)
  end do
  write(*,'(A)') 'Small integers 2..30:'
  do n = 2, 30
    call report(n)
  end do
  write(*,'(A)') 'Selected larger values:'
  do n = 97, 103
    call report(n)
  end do
  call report(7919)
  call report(7920)

contains

  ! Returns .true. if n is prime by Wilson's theorem
  logical function is_prime(n)
    integer, intent(in) :: n
    integer :: i, fact_mod

    if (n <= 1) then
      is_prime = .false.
      return
    end if
    if (n == 2) then
      is_prime = .true.
      return
    end if
    ! Compute (n-1)! mod n incrementally
    fact_mod = 1
    do i = 2, n - 1
      fact_mod = mod(fact_mod * i, n)
    end do
    is_prime = (mod(fact_mod + 1, n) == 0)
  end function is_prime

  subroutine report(n)
    integer, intent(in) :: n
    if (is_prime(n)) then
      write(*,'(I6,A)') n, '  is prime'
    else
      write(*,'(I6,A)') n, '  is not prime'
    end if
  end subroutine report

end program primality
