program EthiopicMult
  implicit none

  print *, ethiopic(17, 34, .true.)

contains

  subroutine halve(v)
    integer, intent(inout) :: v
    v = int(v / 2)
  end subroutine halve

  subroutine doublit(v)
    integer, intent(inout) :: v
    v = v * 2
  end subroutine doublit

  function iseven(x)
    logical :: iseven
    integer, intent(in) :: x
    iseven = mod(x, 2) == 0
  end function iseven

  function ethiopic(multiplier, multiplicand, tutorialized) result(r)
    integer :: r
    integer, intent(in) :: multiplier, multiplicand
    logical, intent(in), optional :: tutorialized

    integer :: plier, plicand
    logical :: tutor

    plier = multiplier
    plicand = multiplicand

    if ( .not. present(tutorialized) ) then
       tutor = .false.
    else
       tutor = tutorialized
    endif

    r = 0

    if ( tutor ) write(*, '(A, I0, A, I0)') "ethiopian multiplication of ", plier, " by ", plicand

    do while(plier >= 1)
       if ( iseven(plier) ) then
          if (tutor) write(*, '(I4, " ", I6, A)') plier, plicand, " struck"
       else
          if (tutor) write(*, '(I4, " ", I6, A)') plier, plicand, " kept"
          r = r + plicand
       endif
       call halve(plier)
       call doublit(plicand)
    end do

  end function ethiopic

end program EthiopicMult
