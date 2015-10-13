program FizzBuzz
implicit none
integer :: i = 1

do i = 1, 100
    if (Mod(i,3) == 0)write(*,"(A)",advance='no')  "Fizz"
    if (Mod(i,5) == 0)write(*,"(A)",advance='no') "Buzz"
    if (Mod(i,3) /= 0 .and. Mod(i,5) /=0 )write(*,"(I3)",advance='no') i
    print *, ""
end do
end program FizzBuzz
