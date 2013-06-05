!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Tue May 21 22:55:08
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a 1223334444
!gfortran -std=f2008 -Wall -ffree-form -fall-intrinsics f.f08 -o f
!  1
!  2  3
!  4  5  6
!  7  8  9 10
! 11 12 13 14 15
!
!
!  1
!  2  3
!  4  5  6
!  7  8  9 10
! 11 12 13 14 15
! 16 17 18 19 20 21
! 22 23 24 25 26 27 28
! 29 30 31 32 33 34 35 36
! 37 38 39 40 41 42 43 44  45
! 46 47 48 49 50 51 52 53  54  55
! 56 57 58 59 60 61 62 63  64  65  66
! 67 68 69 70 71 72 73 74  75  76  77  78
! 79 80 81 82 83 84 85 86  87  88  89  90  91
! 92 93 94 95 96 97 98 99 100 101 102 103 104 105
!
!
!
!Compilation finished at Tue May 21 22:55:08


program p
  integer, dimension(2) :: examples = [5, 14]
  integer :: i
  do i=1, size(examples)
    call floyd(examples(i))
    write(6, '(/)')
  end do

contains

  subroutine floyd(rows)
    integer, intent(in) :: rows
    integer :: n, i, j, k
    integer, dimension(60) :: L
    character(len=504) :: fmt
    n = (rows*(rows+1))/2 ! Gauss's formula
    do i=1,rows ! compute format of final row
      L(i) = 2+int(log10(real(n-rows+i)))
    end do
    k = 0
    do i=1,rows
      do j=1,i
        k = k+1
        write(fmt,'(a2,i1,a1)')'(i',L(j),')'
        write(6,fmt,advance='no') k
      enddo
      write(6,*) ''
    end do
  end subroutine floyd

end program p
