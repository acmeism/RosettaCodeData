program i_o_pairs
  implicit none

  integer :: npairs
  integer :: i
  integer, allocatable :: pairs(:,:)

  read(*,*) npairs
  allocate(pairs(npairs,2))

  do i = 1, npairs
    read(*,*) pairs(i,:)
  end do
  write(*, "(i0)") sum(pairs, 2)

end program
