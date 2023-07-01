program setsize
implicit none

  integer, parameter :: p1 = 6
  integer, parameter :: p2 = 12
  integer, parameter :: r1 = 30
  integer, parameter :: r2 = 1000
  integer, parameter :: r3 = 2
  integer, parameter :: r4 = 4
  integer, parameter :: r5 = 8
  integer, parameter :: r6 = 16
  integer, parameter :: rprec1 = selected_real_kind(p1, r1)
  integer, parameter :: rprec2 = selected_real_kind(p2, r1)
  integer, parameter :: rprec3 = selected_real_kind(p2, r2)
  integer, parameter :: iprec1 = selected_int_kind(r3)
  integer, parameter :: iprec2 = selected_int_kind(r4)
  integer, parameter :: iprec3 = selected_int_kind(r5)
  integer, parameter :: iprec4 = selected_int_kind(r6)

  real(rprec1)    :: n1
  real(rprec2)    :: n2
  real(rprec3)    :: n3
  integer(iprec1) :: n4
  integer(iprec2) :: n5
  integer(iprec3) :: n6
  integer(iprec4) :: n7
  character(30) :: form

  form = "(a7, i11, i10, i6, i9, i8)"
  write(*, "(a)") "KIND NAME   KIND NUMBER   PRECISION        RANGE "
  write(*, "(a)") "                          min   set     min     set"
  write(*, "(a)") "______________________________________________________"
  write(*, form) "rprec1", kind(n1), p1, precision(n1), r1, range(n1)
  write(*, form) "rprec2", kind(n2), p2, precision(n2), r1, range(n2)
  write(*, form) "rprec3", kind(n3), p2, precision(n3), r2, range(n3)
  write(*,*)
  form = "(a7, i11, i25, i8)"
  write(*, form) "iprec1", kind(n4), r3, range(n4)
  write(*, form) "iprec2", kind(n5), r4, range(n5)
  write(*, form) "iprec3", kind(n6), r5, range(n6)
  write(*, form) "iprec4", kind(n7), r6, range(n7)

end program
