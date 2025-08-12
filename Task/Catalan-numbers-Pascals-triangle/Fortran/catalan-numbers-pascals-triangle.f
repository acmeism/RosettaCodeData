  ! Catalan numbers/Pascal's triangle
  !
  ! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
  !             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
  !             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
  ! Note that VMS requires switch $Fortran/ccdefault=LIST
  ! otherwise 1st character of each output line is interpreted as
  ! Carriage Control character.
  ! U.B., July 2025

  program calc_catalan
  implicit none

  integer,  parameter :: nMax=15		! Number of catalan numbers to print
  integer				   	  :: catalan		! result of calculation
  integer     				:: i, j				! Loop indices
  integer					    :: t(nMax+3)	! 1 line of pascal's triangle

  ! straight copy of the algorithm presented in the C++ solution
  !
  ! Try to explain what we are doing:
  !
  ! Pascal's Triangle
  ! # 1: 1
  ! # 2: 1 2 1                    C1 = 2-1 = 1
  ! # 3: 1 3 3 1
  ! # 4: 1 4 6 4 1                C2 = 6-4 = 2
  ! # 5: 1 5 10 10 5 1
  ! # 6: 1 6 15 20 15 6 1         C3 = 20 - 15 = 5
  ! # 7: 1 7 21 35 35 21 7 1
  ! # 8: 1 8 28 56 70 56 28 8 1   C4 = 70 - 56 =  14
  !     t1 2  3  4  5  ...
  ! etc. Note for Cn we need even row #(2*n) up to index n+1.
  !      and we dont need to store all values, just go from row to row.
  t(1) = 0
  t(2) = 1                      ! first odd row (i.e. row #1) will be t(2)+t(1)

  do i=2, nMax+1                ! to calculate C(1)... C(nMax)
    ! get entries of next odd row (at index 2...i).
    ! currently t has values of previous even row
    do j = i, 2, -1
      t(j) = t(j) + t(j-1)
    end do
    ! Now t has values of next odd row.

    ! shift index by 1 so that soon "t" will carry values of next even row
    t(i+1) = t(i)

    ! combine values of previously odd row to become values of even row
    do j=i+1, 2, -1
      t(j) = t(j) + t(j-1)
    end do
    ! Now t has values 1...n+1 of 2n'th row of pascals triangle.

    ! Result: catalan number is center number - (left of center)number
    ! e. g. for C4 its t(5)-t(4) = 70-56 = 14
    ! (remember  i is 5 to calculate C4.)
    catalan = t(i+1) - t(i)

    write (*, '(I0,x) ', ADVANCE='NO')  catalan	  ! all in 1 line
  end do

  write (*,*) ' '                                 ! Terminate output line
  end program calc_catalan
