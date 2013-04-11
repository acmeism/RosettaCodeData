program Five_weekends
  implicit none

  integer :: m, year, nfives = 0, not5 = 0
  logical :: no5weekend

  type month
    integer :: n
    character(3) :: name
  end type month

  type(month) :: month31(7)

  month31(1) = month(13, "Jan")
  month31(2) = month(3,  "Mar")
  month31(3) = month(5,  "May")
  month31(4) = month(7,  "Jul")
  month31(5) = month(8,  "Aug")
  month31(6) = month(10, "Oct")
  month31(7) = month(12, "Dec")

  do year = 1900, 2100
    no5weekend = .true.
    do m = 1, size(month31)
      if(month31(m)%n == 13) then
        if(Day_of_week(1, month31(m)%n, year-1) == 6) then
          write(*, "(a3, i5)") month31(m)%name, year
          nfives = nfives + 1
          no5weekend = .false.
        end if
      else
        if(Day_of_week(1, month31(m)%n, year) == 6) then
          write(*,"(a3, i5)") month31(m)%name, year
          nfives = nfives + 1
          no5weekend = .false.
        end if
      end if
    end do
    if(no5weekend) not5 = not5 + 1
  end do

  write(*, "(a, i0)") "Number of months with five weekends between 1900 and 2100 = ", nfives
  write(*, "(a, i0)") "Number of years between 1900 and 2100 with no five weekend months = ", not5

contains

function Day_of_week(d, m, y)
  integer :: Day_of_week
  integer, intent(in) :: d, m, y
  integer :: j, k

  j = y / 100
  k = mod(y, 100)
  Day_of_week = mod(d + (m+1)*26/10 + k + k/4 + j/4 + 5*j, 7)

end function Day_of_week
end program Five_weekends
