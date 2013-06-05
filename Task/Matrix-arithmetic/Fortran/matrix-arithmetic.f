!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Sat May 18 23:25:42
!
!a=./F && make $a && $a < unixdict.txt
!f95 -Wall -ffree-form F.F -o F
! j example, determinant:    7.00000000
! j example, permanent:      5.00000000
! maxima, determinant:      -360.000000
! maxima, permanent:         900.000000
!
!Compilation finished at Sat May 18 23:25:43



!   NB. example computed by J
!   NB. fixed seed random matrix
!   _2+3 3?.@$5
! 2 _1  1
!_1 _2  1
!_1 _1 _1
!
!   (-/ .*)_2+3 3?.@$5  NB. determinant
!7
!   (+/ .*)_2+3 3?.@$5  NB. permanent
!5

!maxima example
!a: matrix([2, 9, 4], [7, 5, 3], [6, 1, 8])$
!determinant(a);
!-360
!
!permanent(a);
!900


! compute permanent or determinant
program f
  implicit none
  real, dimension(3,3) :: j, m
  data j/ 2,-1, 1,-1,-2, 1,-1,-1,-1/
  data m/2, 9, 4, 7, 5, 3, 6, 1, 8/
  write(6,*) 'j example, determinant: ',det(j,3,-1)
  write(6,*) 'j example, permanent:   ',det(j,3,1)
  write(6,*) 'maxima, determinant:    ',det(m,3,-1)
  write(6,*) 'maxima, permanent:      ',det(m,3,1)

contains

  recursive function det(a,n,permanent) result(accumulation)
    ! setting permanent to 1 computes the permanent.
    ! setting permanent to -1 computes the determinant.
    real, dimension(n,n), intent(in) :: a
    integer, intent(in) :: n, permanent
    real, dimension(n-1, n-1) :: b
    real :: accumulation
    integer :: i, sgn
    if (n .eq. 1) then
      accumulation = a(1,1)
    else
      accumulation = 0
      sgn = 1
      do i=1, n
        b(:, :(i-1)) = a(2:, :i-1)
        b(:, i:) = a(2:, i+1:)
        accumulation = accumulation + sgn * a(1, i) * det(b, n-1, permanent)
        sgn = sgn * permanent
      enddo
    endif
  end function det

end program f
