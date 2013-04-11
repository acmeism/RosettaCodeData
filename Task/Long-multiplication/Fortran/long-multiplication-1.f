module LongMoltiplication
  implicit none

  type longnum
     integer, dimension(:), pointer :: num
  end type longnum

  interface operator (*)
     module procedure longmolt_ll
  end interface

contains

  subroutine longmolt_s2l(istring, num)
    character(len=*), intent(in) :: istring
    type(longnum), intent(out) :: num

    integer :: i, l

    l = len(istring)

    allocate(num%num(l))

    forall(i=1:l) num%num(l-i+1) = iachar(istring(i:i)) - 48

  end subroutine longmolt_s2l

  ! this one performs the moltiplication
  function longmolt_ll(a, b) result(c)
    type(longnum) :: c
    type(longnum), intent(in) :: a, b

    integer, dimension(:,:), allocatable :: t
    integer :: ntlen, i, j

    ntlen = size(a%num) + size(b%num) + 1
    allocate(c%num(ntlen))
    c%num = 0

    allocate(t(size(b%num), ntlen))

    t = 0
    forall(i=1:size(b%num), j=1:size(a%num)) t(i, j+i-1) = b%num(i) * a%num(j)

    do j=2, ntlen
       forall(i=1:size(b%num)) t(i, j) = t(i, j) + t(i, j-1)/10
    end do

    forall(j=1:ntlen) c%num(j) = sum(mod(t(:,j), 10))

    do j=2, ntlen
       c%num(j) = c%num(j) + c%num(j-1)/10
    end do

    c%num = mod(c%num, 10)

    deallocate(t)
  end function longmolt_ll


  subroutine longmolt_print(num)
    type(longnum), intent(in) :: num

    integer :: i, j

    do j=size(num%num), 2, -1
       if ( num%num(j) /= 0 ) exit
    end do

    do i=j, 1, -1
       write(*,"(I1)", advance="no") num%num(i)
    end do
  end subroutine longmolt_print

end module LongMoltiplication
