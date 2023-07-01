program Guess_a_number
  implicit none

  integer, parameter :: limit = 100
  integer :: guess, number
  real :: rnum

  write(*, "(a, i0, a)") "I have chosen a number between 1 and ", limit, &
                         " and you have to try to guess it."
  write(*, "(a/)")  "I will score your guess by indicating whether it is higher, lower or the same as that number"

  call random_seed
  call random_number(rnum)
  number = rnum * limit + 1
  do
    write(*, "(a)", advance="no") "Enter quess: "
    read*, guess
    if(guess < number) then
      write(*, "(a/)") "That is lower"
    else if(guess > number) then
      write(*, "(a/)") "That is higher"
    else
      write(*, "(a)") "That is correct"
      exit
    end if
  end do
end program
