program modular_inverse_task

  implicit none

  write (*,*) inverse (42, 2017)

contains

  ! Returns -1 if there is no inverse. I assume n > 0. The algorithm
  ! is described at
  ! https://en.wikipedia.org/w/index.php?title=Extended_Euclidean_algorithm&oldid=1135569411#Modular_integers
  function inverse (a, n) result (inverse_value)
    integer, intent(in) :: a, n
    integer :: inverse_value

    integer :: t, newt
    integer :: r, newr
    integer :: quotient, remainder, tmp

    if (n <= 0) error stop
    t = 0;  newt = 1
    r = n;  newr = a
    do while (newr /= 0)
       remainder = modulo (r, newr) ! Floor division.
       quotient = (r - remainder) / newr
       tmp = newt;  newt = t - (quotient * newt);  t = tmp
       r   = newr;  newr = remainder
    end do
    if (r > 1) then
       inverse_value = -1
    else if (t < 0) then
       inverse_value = t + n
    else
       inverse_value = t
    end if
  end function inverse

end program modular_inverse_task
