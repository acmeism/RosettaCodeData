program roman_numerals

  implicit none

  write (*, '(a)') roman (2009)
  write (*, '(a)') roman (1666)
  write (*, '(a)') roman (3888)

contains

function roman (n) result (r)

  implicit none
  integer, intent (in) :: n
  integer, parameter   :: d_max = 13
  integer              :: d
  integer              :: m
  integer              :: m_div
  character (32)       :: r
  integer,        dimension (d_max), parameter :: d_dec = &
    & (/1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1/)
  character (32), dimension (d_max), parameter :: d_rom = &
    & (/'M ', 'CM', 'D ', 'CD', 'C ', 'XC', 'L ', 'XL', 'X ', 'IX', 'V ', 'IV', 'I '/)

  r = ''
  m = n
  do d = 1, d_max
    m_div = m / d_dec (d)
    r = trim (r) // repeat (trim (d_rom (d)), m_div)
    m = m - d_dec (d) * m_div
  end do

end function roman

end program roman_numerals
