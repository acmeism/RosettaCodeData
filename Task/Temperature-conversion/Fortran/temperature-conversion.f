Program Temperature
  implicit none

  real :: kel, cel, fah, ran

  write(*,*) "Input Kelvin temperature to convert"
  read(*,*) kel

  call temp_convert(kel, cel, fah, ran)
  write(*, "((a10), f10.3)") "Kelvin", kel
  write(*, "((a10), f10.3)") "Celsius", cel
  write(*, "((a10), f10.3)") "Fahrenheit", fah
  write(*, "((a10), f10.3)") "Rankine", ran

contains

subroutine temp_convert(kelvin, celsius, fahrenheit, rankine)
  real, intent(in)  :: kelvin
  real, intent(out) :: celsius, fahrenheit, rankine

  celsius = kelvin - 273.15
  fahrenheit = kelvin * 1.8 - 459.67
  rankine = kelvin * 1.8

end subroutine
end program
