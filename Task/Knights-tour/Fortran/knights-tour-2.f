!-----------------------------------------------------------------------
!
!     Find Knight’s Tours.
!
!     Using Warnsdorff’s heuristic, find multiple solutions.
!     Optionally accept only closed tours.
!
!     This program is migrated from my implementation for
!     ATS/Postiats. Unlike my FORTRAN 77 implementation (which simply
!     cannot do so), it uses a recursive call.
!
!     Compile with, for instance:
!
!         gfortran -O2 -g -std=f95 -o knights_tour knights_tour.f90
!
!     Usage examples:
!
!         One tour starting at a1, either open or closed:
!
!            echo "a1 1 F" | ./knights_tour
!
!         No more than 2000 closed tours starting at c5:
!
!            echo "c5 2000 T" | ./knights_tour
!
!-----------------------------------------------------------------------

program knights_tour
  implicit none

  character(len = 2) inp__alg
  integer inp__istart
  integer inp__jstart
  integer inp__max_tours
  logical inp__closed

  read (*,*) inp__alg, inp__max_tours, inp__closed
  call alg2ij (inp__alg, inp__istart, inp__jstart)
  call main (inp__istart, inp__jstart, inp__max_tours, inp__closed)

contains

  subroutine main (istart, jstart, max_tours, closed)
    integer, intent(in) :: istart, jstart ! The starting position.
    integer, intent(in) :: max_tours ! The max. no. of tours to print.
    logical, intent(in) :: closed    ! Closed tours only?

    integer board(1:8,1:8)
    integer num_tours_printed

    num_tours_printed = 0
    call init_board (board)
    call explore (board, 1, istart, jstart, max_tours, &
         &        num_tours_printed, closed)
  end subroutine main

  recursive subroutine explore (board, n, i, j, max_tours, &
       &                        num_tours_printed, closed)

    ! Recursively the space of 'Warnsdorffian' knight’s paths, looking
    ! for and printing complete tours.

    integer, intent(inout) :: board(1:8,1:8)
    integer, intent(in) :: n
    integer, intent(in) :: i, j
    integer, intent(in) :: max_tours
    integer, intent(inout) :: num_tours_printed
    logical, intent(in) :: closed

    integer imove(1:8)
    integer jmove(1:8)
    integer k

    if (num_tours_printed < max_tours .and. n /= 0) then
       if (is_good_move (i, j)) then
          call mkmove (board, i, j, n)
          if (n == 63) then
             call find_possible_moves (board, i, j, imove, jmove)
             call try_last_move (board, n + 1, imove(1), jmove(1), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(2), jmove(2), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(3), jmove(3), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(4), jmove(4), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(5), jmove(5), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(6), jmove(6), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(7), jmove(7), &
                  &              num_tours_printed, closed)
             call try_last_move (board, n + 1, imove(8), jmove(8), &
                  &              num_tours_printed, closed)
          else
             call find_next_moves (board, n, i, j, imove, jmove)
             do k = 1, 8
                if (is_good_move (imove(k), jmove(k))) then
                   !
                   ! Here is the recursive call.
                   !
                   call explore (board, n + 1, imove(k), jmove(k), &
                        &        max_tours, num_tours_printed, closed)
                end if
             end do
          end if
          call unmove (board, i, j)
       end if
    end if
  end subroutine explore

  subroutine try_last_move (board, n, i, j, num_tours_printed, closed)
    integer, intent(inout) :: board(1:8,1:8)
    integer, intent(in) :: n
    integer, intent(in) :: i, j
    integer, intent(inout) :: num_tours_printed
    logical, intent(in) :: closed

    integer ipos(1:64)
    integer jpos(1:64)
    integer numpos
    integer idiff
    integer jdiff

    if (is_good_move (i, j)) then
       call mkmove (board, i, j, n)
       if (.not. closed) then
          num_tours_printed = num_tours_printed + 1
          call print_tour (board, num_tours_printed)
       else
          call board2positions (board, ipos, jpos, numpos)
          idiff = abs (i - ipos(1))
          jdiff = abs (j - jpos(1))
          if ((idiff == 1 .and. jdiff == 2) .or. &
               (idiff == 2 .and. jdiff == 1)) then
             num_tours_printed = num_tours_printed + 1
             call print_tour (board, num_tours_printed)
          end if
       end if
       call unmove (board, i, j)
    end if
  end subroutine try_last_move

  subroutine init_board (board)

    ! Initialize a chessboard with empty squares.

    integer, intent(out) :: board(1:8,1:8)

    integer i, j

    do j = 1, 8
       do i = 1, 8
          board(i, j) = -1
       end do
    end do
  end subroutine init_board

  subroutine mkmove (board, i, j, n)

    ! Fill a square with a move number.

    integer, intent(inout) :: board(1:8, 1:8)
    integer, intent(in) :: i, j
    integer, intent(in) :: n

    board(i, j) = n
  end subroutine mkmove

  subroutine unmove (board, i, j)

    ! Unmake a mkmove.

    integer, intent(inout) :: board(1:8, 1:8)
    integer, intent(in) :: i, j

    board(i, j) = -1
  end subroutine unmove

  function is_good_move (i, j)
    logical is_good_move
    integer, intent(in) :: i, j

    is_good_move = (i /= -1 .and. j /= -1)
  end function is_good_move

  subroutine print_tour (board, num_tours_printed)

    ! Print a knight's tour.

    integer, intent(in) :: board(1:8,1:8)
    integer, intent(in) :: num_tours_printed

    write (*, '("Tour number ", I0)') num_tours_printed
    call print_moves (board)
    call print_board (board)
    write (*, '()')
  end subroutine print_tour

  subroutine print_board (board)

    ! Print a chessboard with the move number in each square.

    integer, intent(in) :: board(1:8,1:8)

    integer i, j

    do i = 8, 1, -1
       write (*, '("    ", 8("+----"), "+")')
       write (*, '(I2, " ", 8(" | ", I2), " | ")') &
            i, (board(i, j), j = 1, 8)
    end do
    write (*, '("    ", 8("+----"), "+")')
    write (*, '("   ", 8("    ", A1))') &
         'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'

  end subroutine print_board

  subroutine print_moves (board)

    ! Print the moves of a knight's path, in algebraic notation.

    integer, intent(in) :: board(1:8,1:8)

    integer ipos(1:64)
    integer jpos(1:64)
    integer numpos
    character(len = 2) alg(1:64)
    integer columns(1:8)
    integer k
    integer m

    character(len = 72) lines(1:8)

    call board2positions (board, ipos, jpos, numpos)

    ! Convert the positions to algebraic notation.
    do k = 1, numpos
       call ij2alg (ipos(k), jpos(k), alg(k))
    end do

    ! Fill lines with algebraic notations.
    do m = 1, 8
       columns(m) = 1
    end do
    m = 1
    do k = 1, numpos
       lines(m)(columns(m) : columns(m) + 1) = alg(k)(1:2)
       columns(m) = columns(m) + 2
       if (k /= numpos) then
          lines(m)(columns(m) : columns(m) + 3) = " -> "
          columns(m) = columns(m) + 4
       else if (numpos == 64 .and. &
            ((abs (ipos(numpos) - ipos(1)) == 2 &
            .and. abs (jpos(numpos) - jpos(1)) == 1) .or. &
            ((abs (ipos(numpos) - ipos(1)) == 1 &
            .and. abs (jpos(numpos) - jpos(1)) == 2)))) then
          lines(m)(columns(m) : columns(m) + 8) = " -> cycle"
          columns(m) = columns(m) + 9
       endif
       if (mod (k, 8) == 0) m = m + 1
    end do

    ! Print the lines that have stuff in them.
    do m = 1, 8
       if (columns(m) /= 1) then
          write (*, '(A)') lines(m)(1 : columns(m) - 1)
       end if
    end do

  end subroutine print_moves

  function is_closed (board)

    ! Is a board a closed tour?

    logical is_closed

    integer board(1:8,1:8)
    integer ipos(1:64)        ! The i-positions in order.
    integer jpos(1:64)        ! The j-positions in order.
    integer numpos            ! The number of positions so far.

    call board2positions (board, ipos, jpos, numpos)

    is_closed = (numpos == 64 .and. &
         ((abs (ipos(numpos) - ipos(1)) == 2 &
         .and. abs (jpos(numpos) - jpos(1)) == 1) .or. &
         ((abs (ipos(numpos) - ipos(1)) == 1 &
         .and. abs (jpos(numpos) - jpos(1)) == 2))))

  end function is_closed

  subroutine board2positions (board, ipos, jpos, numpos)

    ! Convert from a board to a list of board positions.

    integer, intent(in) :: board(1:8,1:8)
    integer, intent(out) :: ipos(1:64) ! The i-positions in order.
    integer, intent(out) :: jpos(1:64) ! The j-positions in order.
    integer, intent(out) :: numpos ! The number of positions so far.

    integer i, j

    numpos = 0
    do i = 1, 8
       do j = 1, 8
          if (board(i, j) /= -1) then
             numpos = max (board(i, j), numpos)
             ipos(board(i, j)) = i
             jpos(board(i, j)) = j
          end if
       end do
    end do
  end subroutine board2positions

  subroutine find_next_moves (board, n, i, j, imove, jmove)

    ! Find possible next moves. Prune and sort the moves according to
    ! Warnsdorff's heuristic, keeping only those that have the minimum
    ! number of legal following moves.

    integer, intent(inout) :: board(1:8,1:8)
    integer, intent(in) :: n
    integer, intent(in) :: i, j
    integer, intent(inout) :: imove(1:8)
    integer, intent(inout) :: jmove(1:8)

    integer w1, w2, w3, w4, w5, w6, w7, w8
    integer w

    call find_possible_moves (board, i, j, imove, jmove)

    call count_following (board, n + 1, imove(1), jmove(1), w1)
    call count_following (board, n + 1, imove(2), jmove(2), w2)
    call count_following (board, n + 1, imove(3), jmove(3), w3)
    call count_following (board, n + 1, imove(4), jmove(4), w4)
    call count_following (board, n + 1, imove(5), jmove(5), w5)
    call count_following (board, n + 1, imove(6), jmove(6), w6)
    call count_following (board, n + 1, imove(7), jmove(7), w7)
    call count_following (board, n + 1, imove(8), jmove(8), w8)

    w = pick_w (w1, w2, w3, w4, w5, w6, w7, w8)

    if (w == 0) then
       call disable (imove(1), jmove(1))
       call disable (imove(2), jmove(2))
       call disable (imove(3), jmove(3))
       call disable (imove(4), jmove(4))
       call disable (imove(5), jmove(5))
       call disable (imove(6), jmove(6))
       call disable (imove(7), jmove(7))
       call disable (imove(8), jmove(8))
    else
       if (w /= w1) call disable (imove(1), jmove(1))
       if (w /= w2) call disable (imove(2), jmove(2))
       if (w /= w3) call disable (imove(3), jmove(3))
       if (w /= w4) call disable (imove(4), jmove(4))
       if (w /= w5) call disable (imove(5), jmove(5))
       if (w /= w6) call disable (imove(6), jmove(6))
       if (w /= w7) call disable (imove(7), jmove(7))
       if (w /= w8) call disable (imove(8), jmove(8))
    end if

  end subroutine find_next_moves

  subroutine count_following (board, n, i, j, w)

    ! Count the number of moves possible after an nth move.

    integer, intent(inout) :: board(1:8,1:8)
    integer, intent(in) :: n
    integer, intent(in) :: i, j
    integer, intent(out) :: w

    integer imove(1:8)
    integer jmove(1:8)

    if (is_good_move (i, j)) then
       call mkmove (board, i, j, n)
       call find_possible_moves (board, i, j, imove, jmove)
       w = 0
       if (is_good_move (imove(1), jmove(1))) w = w + 1
       if (is_good_move (imove(2), jmove(2))) w = w + 1
       if (is_good_move (imove(3), jmove(3))) w = w + 1
       if (is_good_move (imove(4), jmove(4))) w = w + 1
       if (is_good_move (imove(5), jmove(5))) w = w + 1
       if (is_good_move (imove(6), jmove(6))) w = w + 1
       if (is_good_move (imove(7), jmove(7))) w = w + 1
       if (is_good_move (imove(8), jmove(8))) w = w + 1
       call unmove (board, i, j)
    else
       ! The nth move itself is impossible.
       w = 0
    end if

  end subroutine count_following

  function pick_w (w1, w2, w3, w4, w5, w6, w7, w8) result (w)

    ! From w1..w8, pick out the least nonzero value (or zero if they
    ! all equal zero).

    integer, intent(in) :: w1, w2, w3, w4, w5, w6, w7, w8
    integer w

    w = 0
    w = pick_w1 (w, w1)
    w = pick_w1 (w, w2)
    w = pick_w1 (w, w3)
    w = pick_w1 (w, w4)
    w = pick_w1 (w, w5)
    w = pick_w1 (w, w6)
    w = pick_w1 (w, w7)
    w = pick_w1 (w, w8)
  end function pick_w

  function pick_w1 (u, v)

    ! A small function used by pick_w.

    integer pick_w1
    integer, intent(in) :: u, v

    if (v == 0) then
       pick_w1 = u
    else if (u == 0) then
       pick_w1 = v
    else
       pick_w1 = min (u, v)
    end if
  end function pick_w1

  subroutine find_possible_moves (board, i, j, imove, jmove)

    ! Find moves that are possible from a position.

    integer, intent(in) :: board(1:8,1:8)
    integer, intent(in) :: i, j
    integer, intent(out) :: imove(1:8)
    integer, intent(out) :: jmove(1:8)

    call trymov (board, i + 1, j + 2, imove(1), jmove(1))
    call trymov (board, i + 2, j + 1, imove(2), jmove(2))
    call trymov (board, i + 1, j - 2, imove(3), jmove(3))
    call trymov (board, i + 2, j - 1, imove(4), jmove(4))
    call trymov (board, i - 1, j + 2, imove(5), jmove(5))
    call trymov (board, i - 2, j + 1, imove(6), jmove(6))
    call trymov (board, i - 1, j - 2, imove(7), jmove(7))
    call trymov (board, i - 2, j - 1, imove(8), jmove(8))
  end subroutine find_possible_moves

  subroutine trymov (board, i, j, imove, jmove)

    ! Try a move to square (i, j).

    integer, intent(in) :: board(1:8,1:8)
    integer, intent(in) :: i, j
    integer, intent(inout) :: imove, jmove

    call disable (imove, jmove)
    if (1 <= i .and. i <= 8 .and. 1 <= j .and. j <= 8) then
       if (square_is_empty (board, i, j)) then
          call enable (i, j, imove, jmove)
       end if
    end if

  end subroutine trymov

  function square_is_empty (board, i, j)
    logical square_is_empty
    integer, intent(in) :: board(1:8,1:8)
    integer, intent(in) :: i, j

    square_is_empty = (board(i, j) == -1)
  end function square_is_empty

  subroutine enable (i, j, imove, jmove)

    ! Enable a potential move.

    integer, intent(in) :: i, j
    integer, intent(inout) :: imove, jmove

    imove = i
    jmove = j
  end subroutine enable

  subroutine disable (imove, jmove)

    ! Disable a potential move.

    integer, intent(out) :: imove, jmove

    imove = -1
    jmove = -1
  end subroutine disable

  subroutine alg2ij (alg, i, j)

    ! Convert, for instance, 'c5' to i=3,j=5.

    character(len = 2), intent(in) :: alg
    integer, intent(out) :: i, j

    if (alg(1:1) == 'a') j = 1
    if (alg(1:1) == 'b') j = 2
    if (alg(1:1) == 'c') j = 3
    if (alg(1:1) == 'd') j = 4
    if (alg(1:1) == 'e') j = 5
    if (alg(1:1) == 'f') j = 6
    if (alg(1:1) == 'g') j = 7
    if (alg(1:1) == 'h') j = 8

    if (alg(2:2) == '1') i = 1
    if (alg(2:2) == '2') i = 2
    if (alg(2:2) == '3') i = 3
    if (alg(2:2) == '4') i = 4
    if (alg(2:2) == '5') i = 5
    if (alg(2:2) == '6') i = 6
    if (alg(2:2) == '7') i = 7
    if (alg(2:2) == '8') i = 8

  end subroutine alg2ij

  subroutine ij2alg (i, j, alg)

    ! Convert, for instance, i=3,j=5 to 'c5'.

    integer, intent(in) :: i, j
    character(len = 2), intent(out) :: alg

    character alg1
    character alg2

    if (j == 1) alg1 = 'a'
    if (j == 2) alg1 = 'b'
    if (j == 3) alg1 = 'c'
    if (j == 4) alg1 = 'd'
    if (j == 5) alg1 = 'e'
    if (j == 6) alg1 = 'f'
    if (j == 7) alg1 = 'g'
    if (j == 8) alg1 = 'h'

    if (i == 1) alg2 = '1'
    if (i == 2) alg2 = '2'
    if (i == 3) alg2 = '3'
    if (i == 4) alg2 = '4'
    if (i == 5) alg2 = '5'
    if (i == 6) alg2 = '6'
    if (i == 7) alg2 = '7'
    if (i == 8) alg2 = '8'

    alg(1:1) = alg1
    alg(2:2) = alg2

  end subroutine ij2alg

end program

!-----------------------------------------------------------------------
