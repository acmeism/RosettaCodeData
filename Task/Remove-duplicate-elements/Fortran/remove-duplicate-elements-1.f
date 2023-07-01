program remove_dups
  implicit none
  integer :: example(12)         ! The input
  integer :: res(size(example))  ! The output
  integer :: k                   ! The number of unique elements
  integer :: i, j

  example = [1, 2, 3, 2, 2, 4, 5, 5, 4, 6, 6, 5]
  k = 1
  res(1) = example(1)
  outer: do i=2,size(example)
     do j=1,k
        if (res(j) == example(i)) then
           ! Found a match so start looking again
           cycle outer
        end if
     end do
     ! No match found so add it to the output
     k = k + 1
     res(k) = example(i)
  end do outer
  write(*,advance='no',fmt='(a,i0,a)') 'Unique list has ',k,' elements: '
  write(*,*) res(1:k)
end program remove_dups
