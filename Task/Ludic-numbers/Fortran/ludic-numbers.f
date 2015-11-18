program ludic_numbers
  implicit none

  integer, parameter :: nmax = 25000
  logical :: ludic(nmax) = .true.
  integer :: i, j, n

  do i = 2, nmax / 2
    if (ludic(i)) then
      n = 0
      do j = i+1, nmax
        if(ludic(j)) n = n + 1
        if(n == i) then
          ludic(j) = .false.
          n = 0
        end if
      end do
    end if
  end do

  write(*, "(a)", advance = "no") "First 25 Ludic numbers: "
  n = 0
  do i = 1, nmax
    if(ludic(i)) then
      write(*, "(i0, 1x)", advance = "no") i
      n = n + 1
    end if
    if(n == 25) exit
  end do

  write(*, "(/, a)", advance = "no") "Ludic numbers below 1000: "
  write(*, "(i0)") count(ludic(:999))

  write(*, "(a)", advance = "no") "Ludic numbers 2000 to 2005: "
  n = 0
  do i = 1, nmax
    if(ludic(i)) then
       n = n + 1
       if(n >= 2000) then
         write(*, "(i0, 1x)", advance = "no") i
         if(n == 2005) exit
       end if
     end if
  end do

  write(*, "(/, a)", advance = "no") "Ludic Triplets below 250: "
  do i = 1, 243
    if(ludic(i) .and. ludic(i+2) .and. ludic(i+6)) then
       write(*, "(a, 2(i0, 1x), i0, a, 1x)", advance = "no") "[", i, i+2, i+6, "]"
    end if
  end do

end program
