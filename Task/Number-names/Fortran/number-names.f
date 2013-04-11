program spell

  implicit none
  integer :: e
  integer :: i
  integer :: m
  integer :: n
  character (9), dimension (19), parameter :: small =       &
    & (/'one      ', 'two      ', 'three    ', 'four     ', &
    &   'five     ', 'six      ', 'seven    ', 'eight    ', &
    &   'nine     ', 'ten      ', 'eleven   ', 'twelve   ', &
    &   'thirteen ', 'fourteen ', 'fifteen  ', 'sixteen  ', &
    &   'seventeen', 'eighteen ', 'nineteen '/)
  character (7), dimension (2 : 9), parameter :: tens =        &
    & (/'twenty ', 'thirty ', 'forty  ', 'fifty  ', 'sixty  ', &
    &   'seventy', 'eighty ', 'ninety '/)
  character (8), dimension (3), parameter :: big = &
    & (/'thousand', 'million ', 'billion '/)
  character (256) :: r

  do
    read (*, *, iostat = i) n
    if (i /= 0) then
      exit
    end if
    if (n == 0) then
      r = 'zero'
    else
      r = ''
      m = abs (n)
      e = 0
      do
        if (m == 0) then
          exit
        end if
        if (modulo (m, 1000) > 0) then
          if (e > 0) then
            r = trim (big (e)) // ' ' // r
          end if
          if (modulo (m, 100) > 0) then
            if (modulo (m, 100) < 20) then
              r = trim (small (modulo (m, 100))) // ' ' // r
            else
              if (modulo (m, 10) > 0) then
                r = trim (small (modulo (m, 10))) // ' ' // r
                r = trim (tens (modulo (m, 100) / 10)) // '-' // r
              else
                r = trim (tens (modulo (m, 100) / 10)) // ' ' // r
              end if
            end if
          end if
          if (modulo (m, 1000) / 100 > 0) then
            r = 'hundred' // ' ' // r
            r = trim (small (modulo (m, 1000) / 100)) // ' ' // r
          end if
        end if
        m = m / 1000
        e = e + 1
      end do
      if (n < 0) then
        r = 'negative' // ' ' // r
      end if
    end if
    write (*, '(a)') trim (r)
  end do

end program spell
