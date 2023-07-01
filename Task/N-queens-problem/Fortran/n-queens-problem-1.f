program Nqueens
  implicit none

  integer, parameter :: n = 8  ! size of board
  integer :: file = 1, rank = 1, queens = 0
  integer :: i
  logical :: board(n,n) = .false.

  do while (queens < n)
    board(file, rank) = .true.
    if(is_safe(board, file, rank)) then
      queens = queens + 1
      file = 1
      rank = rank + 1
    else
      board(file, rank) = .false.
      file = file + 1
      do while(file > n)
         rank = rank - 1
         if (rank < 1) then
           write(*, "(a,i0)") "No solution for n = ", n
           stop
         end if
         do i = 1, n
           if (board(i, rank)) then
             file = i
             board(file, rank) = .false.
             queens = queens - 1
             file = i + 1
             exit
           end if
         end do
       end do
    end if
  end do

  call Printboard(board)

contains

function is_safe(board, file, rank)
  logical :: is_safe
  logical, intent(in) :: board(:,:)
  integer, intent(in) :: file, rank
  integer :: i, f, r

  is_safe = .true.
  do i = rank-1, 1, -1
    if(board(file, i)) then
      is_safe = .false.
      return
    end if
  end do

  f = file - 1
  r = rank - 1
  do while(f > 0 .and. r > 0)
    if(board(f, r)) then
      is_safe = .false.
      return
    end if
    f = f - 1
    r = r - 1
  end do

  f = file + 1
  r = rank - 1
  do while(f <= n .and. r > 0)
    if(board(f, r)) then
      is_safe = .false.
      return
    end if
    f = f + 1
    r = r - 1
  end do
end function

subroutine Printboard(board)
  logical, intent(in) :: board(:,:)
  character(n*4+1) :: line
  integer :: f, r

  write(*, "(a, i0)") "n = ", n
  line = repeat("+---", n) // "+"
  do r = 1, n
    write(*, "(a)") line
    do f = 1, n
      write(*, "(a)", advance="no") "|"
      if(board(f, r)) then
        write(*, "(a)", advance="no") " Q "
      else if(mod(f+r, 2) == 0) then
        write(*, "(a)", advance="no") "   "
      else
        write(*, "(a)", advance="no") "###"
      end if
    end do
    write(*, "(a)") "|"
  end do
  write(*, "(a)") line
end subroutine
end program
