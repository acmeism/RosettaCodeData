program Roman_decode
  implicit none

  write(*,*) decode("MCMXC"), decode("MMVIII"), decode("MDCLXVI")

contains

function decode(roman) result(arabic)
  character(*), intent(in) :: roman
  integer :: i, n, lastval, arabic

  arabic = 0
  lastval = 0
  do i = len(roman), 1, -1
    select case(roman(i:i))
      case ('M','m')
        n = 1000
      case ('D','d')
        n = 500
      case ('C','c')
        n = 100
      case ('L','l')
        n = 50
      case ('X','x')
        n = 10
      case ('V','v')
        n = 5
      case ('I','i')
        n = 1
      case default
        n = 0
    end select
    if (n < lastval) then
      arabic = arabic - n
    else
      arabic = arabic + n
    end if
    lastval = n
  end do
end function decode
end program Roman_decode
