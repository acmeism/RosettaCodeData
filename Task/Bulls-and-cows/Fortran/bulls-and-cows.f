module bac
  implicit none

contains

  subroutine Gennum(n)
    integer, intent(out) :: n(4)
    integer :: i, j
    real :: r

    call random_number(r)
    n(1) = int(r * 9.0) + 1
    i = 2

outer: do while (i <= 4)
         call random_number(r)
         n(i) = int(r * 9.0) + 1
inner:   do j = i-1 , 1, -1
           if (n(j) == n(i)) cycle outer
         end do inner
         i = i + 1
       end do outer

  end subroutine Gennum

  subroutine Score(n, guess, b, c)
    character(*), intent(in) :: guess
    integer, intent(in) :: n(0:3)
    integer, intent(out) :: b, c
    integer :: digit, i, j, ind

    b = 0; c = 0
    do i = 1, 4
      read(guess(i:i), "(i1)") digit
      if (digit == n(i-1)) then
        b = b + 1
      else
        do j = i, i+2
          ind = mod(j, 4)
          if (digit == n(ind)) then
            c = c + 1
            exit
          end if
        end do
      end if
    end do

 end subroutine Score

end module bac

program Bulls_and_Cows
   use bac
   implicit none

   integer :: n(4)
   integer :: bulls=0, cows=0, tries=0
   character(4) :: guess

   call random_seed
   call Gennum(n)

   write(*,*) "I have selected a number made up of 4 digits (1-9) without repetitions."
   write(*,*) "You attempt to guess this number."
   write(*,*) "Every digit in your guess that is in the correct position scores 1 Bull"
   write(*,*) "Every digit in your guess that is in an incorrect position scores 1 Cow"
   write(*,*)

   do while (bulls /= 4)
     write(*,*) "Enter a 4 digit number"
     read*, guess
     if (verify(guess, "123456789") /= 0) then
       write(*,*) "That is an invalid entry. Please try again."
       cycle
     end if
     tries = tries + 1
     call Score (n, guess, bulls, cows)
     write(*, "(a, i1, a, i1, a)") "You scored ", bulls, " bulls and ", cows, " cows"
     write(*,*)
   end do

   write(*,"(a,i0,a)") "Congratulations! You correctly guessed the correct number in ", tries, " attempts"

end program Bulls_and_Cows
