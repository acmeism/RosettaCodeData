program Guess_a_number_Player
  implicit none

  integer, parameter :: limit = 100
  integer :: guess, mx = limit, mn = 1
  real :: rnum
  character(1) :: score

  write(*, "(a, i0, a)") "Think of a number between 1 and ", limit, &
                         " and I will try to guess it."
  write(*, "(a)")  "You score my guess by entering: h if my guess is higher than that number"
  write(*, "(a)")  "                                l if my guess is lower than that number"
  write(*, "(a/)") "                                c if my guess is the same as that number"

  call random_seed
  call random_number(rnum)
  guess = rnum * limit + 1
  do
    write(*, "(a, i0, a,)", advance='no') "My quess is: ", guess, "   Score(h, l or c)?: "
    read*, score
    select case(score)
      case("l", "L")
        mn = guess
        guess = (mx-guess+1) / 2 + mn

      case("h", "H")
        mx = guess
        guess = mx - (guess-mn+1) / 2

      case("c", "C")
        write(*, "(a)") "I solved it!"
        exit

      case default
        write(*, "(a)") "I did not understand that"
    end select
  end do
end program
