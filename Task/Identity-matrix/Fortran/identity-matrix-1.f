program identitymatrix

  real, dimension(:, :), allocatable :: I
  character(len=8) :: fmt
  integer :: ms, j

  ms = 10   ! the desired size

  allocate(I(ms,ms))
  I = 0                           ! Initialize the array.
  forall(j = 1:ms) I(j,j) = 1     ! Set the diagonal.

  ! I is the identity matrix, let's show it:

  write (fmt, '(A,I2,A)') '(', ms, 'F6.2)'
  ! if you consider to have used the (row, col) convention,
  ! the following will print the transposed matrix (col, row)
  ! but I' = I, so it's not important here
  write (*, fmt) I(:,:)

  deallocate(I)

end program identitymatrix
