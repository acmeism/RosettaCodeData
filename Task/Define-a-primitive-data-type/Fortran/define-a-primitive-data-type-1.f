module Bounded
  implicit none

  type BoundedInteger
     integer, private :: v         ! we cannot allow direct access to this, or we
     integer, private :: from, to  !   can't check the bounds!
     logical, private :: critical
  end type BoundedInteger

  interface assignment(=)
     module procedure bounded_assign_bb, bounded_assign_bi !, &
                    ! bounded_assign_ib
  end interface

  interface operator(+)
     module procedure bounded_add_bbb !, bounded_add_bbi, &
                    ! bounded_add_bib, bounded_add_ibb,   &
                    ! bounded_add_iib, bounded_add_ibi,   &
                    ! bounded_add_bii
  end interface

  private :: bounded_assign_bb, bounded_assign_bi, &
             bounded_add_bbb

contains

  subroutine set_bound(bi, lower, upper, critical, value)
    type(BoundedInteger), intent(out) :: bi
    integer, intent(in) :: lower, upper
    integer, intent(in), optional :: value
    logical, intent(in), optional :: critical

    bi%from = min(lower, upper)
    bi%to = max(lower, upper)
    if ( present(critical) ) then
       bi%critical = critical
    else
       bi%critical = .false.
    end if
    if ( present(value) ) then
       bi = value
    end if
  end subroutine set_bound

  subroutine bounded_assign_bb(a, b)
    type(BoundedInteger), intent(out) :: a
    type(BoundedInteger), intent(in)  :: b

    call bounded_assign_bi(a, b%v)

  end subroutine bounded_assign_bb


  subroutine bounded_assign_bi(a, b)
    type(BoundedInteger), intent(out) :: a
    integer,              intent(in)  :: b

    if ( (a%from <= b) .and. (a%to >= b) ) then
       a%v = b
    else
       write(0,*) "BoundedInteger: out of bound assignment"
       if ( a%critical ) then
          stop
       else
          if ( b < a%from ) then
             a%v = a%from
          else
             a%v = a%to
          end if
          write(0,"(A,' (',I0, ')')") "BoundedInteger: set to nearest bound", a%v
       end if
    end if
  end subroutine bounded_assign_bi


  function bounded_add_bbb(a, b) result(c)
    type(BoundedInteger) :: c
    type(BoundedInteger), intent(in) :: a, b

    integer :: t

    c%from = max(a%from, b%from)
    c%to   = min(a%to,   b%to)
    t = a%v + b%v
    if ( c%from <= t .and. c%to >= t ) then
       c%v = t
    else
       write(0,*) "BoundedInteger: out of bound sum"
       if ( a%critical .or. b%critical ) then
          stop
       else
          if ( t < c%from ) then
             c%v = c%from
          else
             c%v = c%to
          end if
          write(0,"(A,' (',I0,')')") "BoundedInteger: set to nearest bound", c%v
       end if
    end if
  end function bounded_add_bbb

end module Bounded
