Program Cholesky_decomp
! *************************************************!
! LBH @ ULPGC 06/03/2014
! Compute the Cholesky decomposition for a matrix A
! after the attached
! http://rosettacode.org/wiki/Cholesky_decomposition
! note that the matrix A is complex since there might
! be values, where the sqrt has complex solutions.
! Here, only the real values are taken into account
!*************************************************!
implicit none

INTEGER, PARAMETER :: m=3 !rows
INTEGER, PARAMETER :: n=3 !cols
COMPLEX, DIMENSION(m,n) :: A
REAL, DIMENSION(m,n) :: L
REAL :: sum1, sum2
INTEGER i,j,k

! Assign values to the matrix
A(1,:)=(/ 25,  15,  -5 /)
A(2,:)=(/ 15,  18,   0 /)
A(3,:)=(/ -5,   0,  11 /)
! !!!!!!!!!!!another example!!!!!!!
! A(1,:) = (/ 18,  22,   54,   42 /)
! A(2,:) = (/ 22,  70,   86,   62 /)
! A(3,:) = (/ 54,  86,  174,  134 /)
! A(4,:) = (/ 42,  62,  134,  106 /)





! Initialize values
L(1,1)=real(sqrt(A(1,1)))
L(2,1)=A(2,1)/L(1,1)
L(2,2)=real(sqrt(A(2,2)-L(2,1)*L(2,1)))
L(3,1)=A(3,1)/L(1,1)
! for greater order than m,n=3 add initial row value
! for instance if m,n=4 then add the following line
! L(4,1)=A(4,1)/L(1,1)





do i=1,n
    do k=1,i
        sum1=0
        sum2=0
        do j=1,k-1
        if (i==k) then
            sum1=sum1+(L(k,j)*L(k,j))
            L(k,k)=real(sqrt(A(k,k)-sum1))
        elseif (i > k) then
            sum2=sum2+(L(i,j)*L(k,j))
            L(i,k)=(1/L(k,k))*(A(i,k)-sum2)
        else
            L(i,k)=0
        end if
        end do
    end do
end do

! write output
do i=1,m
    print "(3(1X,F6.1))",L(i,:)
end do

End program Cholesky_decomp
