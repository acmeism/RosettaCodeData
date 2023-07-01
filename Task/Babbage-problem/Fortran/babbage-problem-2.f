program babbage
  implicit none
  integer :: n

  n=1
  do while (mod(n*n,1000000) .ne. 269696)
     n = n + 1
  end do
  print*, n
end program babbage
