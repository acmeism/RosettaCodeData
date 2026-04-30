program calculate_e
  use iso_fortran_env, only: ep => real128
  implicit none

  integer :: n
  real(kind=ep) :: sum_e, term, eps, c, y, t
  real(kind=ep), parameter :: e_ref = 2.7182818284590452353602874713526624_ep

  sum_e = 0.0_ep
  c = 0.0_ep
  n = 0
  eps = epsilon(1.0_ep)

  do
    term = 1.0_ep / gamma(real(n + 1, kind=ep))
    if (term < eps) exit

    ! Kahan summation to keep precision
    y = term - c
    t = sum_e + y
    c = (t - sum_e) - y
    sum_e = t

    n = n + 1
  end do

  write(*,'(a,t45,a)') 'Literature supplied value = ', &
       '2.7182818284590452353602874713526624'
  write(*,'(a,t41,F40.34)') 'Approximation of e using Taylor series = ', sum_e
  write(*,'(a,t45,EN0.5)') 'Variance = ', abs(sum_e - e_ref)
  write(*,*) 'Converged after', n, 'terms.'
end program calculate_e
