module modAcc
implicit none
private
integer, public, parameter :: KRL = selected_real_kind(14)

type, public :: AccType
    real(KRL), private :: dn, dsum
    complex(KRL), private :: fn, fsum
    integer, private :: jn, jsum, icod
    contains
    procedure, private :: initd, initf, initi
    generic, public :: init => initd, initf, initi
    procedure, private :: dfun, ffun, jfun
    generic, public :: fun => dfun, jfun, ffun
end type AccType


contains

subroutine initd(self, dd)
    class(AccType), intent(inout) :: self
    real(KRL), intent(in) :: dd
    self%dn = dd
    self%icod = 1
end subroutine initd

subroutine initf(self, ff)
    class(AccType), intent(inout) :: self
    complex(KRL), intent(in) :: ff
    self%fn = ff
    self%icod = 2
end subroutine initf

subroutine initi(self, jj)
    class(AccType), intent(inout) :: self
    integer, intent(in) :: jj
    self%jn = jj
    self%icod = 3
end subroutine initi

real(KRL) function dfun(self, di)
    class(AccType), intent(inout) :: self
    real(KRL), intent(in) :: di
    self%dsum = self%dsum + di
    dfun = self%dn + self%dsum
end function dfun


complex(KRL) function ffun(self, fi)
    class(AccType), intent(inout) :: self
    complex(KRL), intent(in) :: fi
    self%fsum = self%fsum + fi
    ffun = self%fn + self%fsum
end function ffun


integer function jfun(self, ji)
    class(AccType), intent(inout) :: self
    integer, intent(in) :: ji
    self%jsum = self%jsum + ji
    jfun = self%jn + self%jsum
end function jfun

end module modAcc


program test
    use modAcc
    implicit none
    type(AccType) :: x, y
    integer :: itemp
    real(KRL) :: temp
    call x%init(1.0_KRL)
    temp = x%fun(5.0_KRL)
    call y%init(3)
    print *, x%fun(2.3_KRL)
    itemp = y%fun(5)
    print *, y%fun(2)
end program test
