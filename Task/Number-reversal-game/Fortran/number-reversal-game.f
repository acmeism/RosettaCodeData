program Reversal_game
  implicit none

  integer :: list(9) = (/ 1, 2, 3, 4, 5, 6, 7, 8, 9 /)
  integer :: pos, attempts = 0

  call random_seed
  do while (sorted(list))
    call Shuffle(list)
  end do
  write(*, "(9i5)") list
  write(*,*)
  do while (.not. Sorted(list))
    write(*, "(a)", advance="no") "How many numbers from the left do you want to reverse? : "
    read*, pos
    attempts = attempts + 1
    list(1:pos) = list(pos:1:-1)
    write(*, "(9i5)") list
    write(*,*)
  end do
  write(*,*)
  write(*, "(a,i0,a)") "Congratulations! Solved in ", attempts, " attempts"

contains

subroutine Shuffle(a)
  integer, intent(inout) :: a(:)
  integer :: i, randpos, temp
  real :: r

  do i = size(a), 2, -1
    call random_number(r)
    randpos = int(r * i) + 1
    temp = a(randpos)
    a(randpos) = a(i)
    a(i) = temp
  end do
end subroutine

function Sorted(a)
  logical :: Sorted
  integer, intent(in) :: a(:)
  integer :: i

  do i = 1, size(a)-1
    if(list(i+1) /= list(i)+1) then
      Sorted = .false.
      return
    end if
  end do
  Sorted = .true.
end function

end program
