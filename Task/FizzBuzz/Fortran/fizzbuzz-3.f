program fizzbuzz_select
    integer :: i

    do i = 1, 100
       select case (mod(i,15))
          case 0;        print *, 'FizzBuzz'
          case 3,6,9,12; print *, 'Fizz'
          case 5,10;     print *, 'Buzz'
          case default;  print *, i
       end select
    end do
 end program fizzbuzz_select
