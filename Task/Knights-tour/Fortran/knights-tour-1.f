C-----------------------------------------------------------------------
C
C     Find Knight’s Tours.
C
C     Using Warnsdorff’s heuristic, find multiple solutions.
C     Optionally accept only closed tours.
C
C     This program is migrated from my implementation for ATS/Postiats.
C     Arrays with dimension 1:64 take the place of stack frames.
C
C     Compile with, for instance:
C
C         gfortran -O2 -g -std=legacy -o knights_tour knights_tour.f
C
C     or
C
C         f2c knights_tour.f
C         cc -O -o knights_tour knights_tour.c -lf2c
C
C     Usage examples:
C
C         One tour starting at a1, either open or closed:
C
C            echo "a1 1 F" | ./knights_tour
C
C         No more than 2000 closed tours starting at c5:
C
C            echo "c5 2000 T" | ./knights_tour
C
C-----------------------------------------------------------------------

      program ktour
      implicit none

      character*2 alg
      integer i, j
      integer mxtour
      logical closed

      read (*,*) alg, mxtour, closed
      call alg2ij (alg, i, j)
      call explor (i, j, mxtour, closed)

      end

C-----------------------------------------------------------------------

      subroutine explor (istart, jstart, mxtour, closed)
      implicit none

C     Explore the space of 'Warnsdorffian' knight’s paths, looking for
C     and printing complete tours.

      integer istart, jstart    ! The starting position.
      integer mxtour            ! The maximum number of tours to print.
      logical closed            ! Closed tours only?

      integer board(1:8,1:8)
      integer imove(1:8,1:64)
      integer jmove(1:8,1:64)
      integer nmove(1:64)
      integer n
      integer itours
      logical goodmv
      logical isclos

      itours = 0
      call initbd (board)
      n = 1
      nmove(1) = 8
      imove(8, 1) = istart
      jmove(8, 1) = jstart

 1000 if (itours .lt. mxtour .and. n .ne. 0) then

         if (nmove(n) .eq. 9) then
            n = n - 1
            if (n .ne. 0) then
               call unmove (board, imove, jmove, nmove, n)
               nmove(n) = nmove(n) + 1
            end if
         else if (goodmv (imove, nmove, n)) then
            call mkmove (board, imove, jmove, nmove, n)
            if (n .eq. 64) then
               if (.not. closed) then
                  itours = itours + 1
                  call prnt (board, itours)
               else if (isclos (board)) then
                  itours = itours + 1
                  call prnt (board, itours)
               end if
               call unmove (board, imove, jmove, nmove, n)
               nmove(n) = 9
            else if (n .eq. 63) then
               call possib (board, n, imove, jmove, nmove)
               n = n + 1
               nmove(n) = 1
            else
               call nxtmov (board, n, imove, jmove, nmove)
               n = n + 1
               nmove(n) = 1
            end if
         else
            nmove(n) = nmove(n) + 1
         end if

         goto 1000
      end if

      end

C-----------------------------------------------------------------------

      subroutine initbd (board)
      implicit none

C     Initialize a chessboard with empty squares.

      integer board(1:8,1:8)

      integer i, j

      do 1010 j = 1, 8
         do 1000 i = 1, 8
            board(i, j) = -1
 1000    continue
 1010 continue

      end

C-----------------------------------------------------------------------

      subroutine mkmove (board, imove, jmove, nmove, n)
      implicit none

C     Fill a square with a move number.

      integer board(1:8, 1:8)
      integer imove(1:8, 1:64)
      integer jmove(1:8, 1:64)
      integer nmove(1:64)
      integer n

      board(imove(nmove(n), n), jmove(nmove(n), n)) = n

      end

C-----------------------------------------------------------------------

      subroutine unmove (board, imove, jmove, nmove, n)
      implicit none

C     Unmake a mkmove.

      integer board(1:8, 1:8)
      integer imove(1:8, 1:64)
      integer jmove(1:8, 1:64)
      integer nmove(1:64)
      integer n

      board(imove(nmove(n), n), jmove(nmove(n), n)) = -1

      end

C-----------------------------------------------------------------------

      function goodmv (imove, nmove, n)
      implicit none

      logical goodmv
      integer imove(1:8, 1:64)
      integer nmove(1:64)
      integer n

      goodmv = (imove(nmove(n), n) .ne. -1)

      end

C-----------------------------------------------------------------------

      subroutine prnt (board, itours)
      implicit none

C     Print a knight's tour.

      integer board(1:8,1:8)
      integer itours

10000 format (1X)

C     The following plethora of format statements seemed a simple way to
C     get this working with f2c. (For gfortran, the 'I0' format
C     sufficed.)
10010 format (1X, "Tour number ", I1)
10020 format (1X, "Tour number ", I2)
10030 format (1X, "Tour number ", I3)
10040 format (1X, "Tour number ", I4)
10050 format (1X, "Tour number ", I5)
10060 format (1X, "Tour number ", I6)
10070 format (1X, "Tour number ", I20)

      if (itours .lt. 10) then
         write (*, 10010) itours
      else if (itours .lt. 100) then
         write (*, 10020) itours
      else if (itours .lt. 1000) then
         write (*, 10030) itours
      else if (itours .lt. 10000) then
         write (*, 10040) itours
      else if (itours .lt. 100000) then
         write (*, 10050) itours
      else if (itours .lt. 1000000) then
         write (*, 10060) itours
      else
         write (*, 10070) itours
      end if
      call prntmv (board)
      call prntbd (board)
      write (*, 10000)

      end

C-----------------------------------------------------------------------

      subroutine prntbd (board)
      implicit none

C     Print a chessboard with the move number in each square.

      integer board(1:8,1:8)

      integer i, j

10000 format (1X, "    ", 8("+----"), "+")
10010 format (1X, I2, " ", 8(" | ", I2), " | ")
10020 format (1X, "   ", 8("    ", A1))

      do 1000 i = 8, 1, -1
         write (*, 10000)
         write (*, 10010) i, (board(i, j), j = 1, 8)
 1000 continue
      write (*, 10000)
      write (*, 10020) 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'

      end

C-----------------------------------------------------------------------

      subroutine prntmv (board)
      implicit none

C     Print the moves of a knight's path, in algebraic notation.

      integer board(1:8,1:8)

      integer ipos(1:64)
      integer jpos(1:64)
      integer numpos
      character*2 alg(1:64)
      integer columns(1:8)
      integer k
      integer m

      character*72 lines(1:8)

10000 format (1X, A)

      call bd2pos (board, ipos, jpos, numpos)

C     Convert the positions to algebraic notation.
      do 1000 k = 1, numpos
         call ij2alg (ipos(k), jpos(k), alg(k))
 1000 continue

C     Fill lines with algebraic notations.
      do 1020 m = 1, 8
         columns(m) = 1
 1020 continue
      m = 1
      do 1100 k = 1, numpos
         lines(m)(columns(m) : columns(m) + 1) = alg(k)(1:2)
         columns(m) = columns(m) + 2
         if (k .ne. numpos) then
            lines(m)(columns(m) : columns(m) + 3) = " -> "
            columns(m) = columns(m) + 4
         else if (numpos .eq. 64 .and.
     $           ((abs (ipos(numpos) - ipos(1)) .eq. 2
     $           .and. abs (jpos(numpos) - jpos(1)) .eq. 1) .or.
     $           ((abs (ipos(numpos) - ipos(1)) .eq. 1
     $           .and. abs (jpos(numpos) - jpos(1)) .eq. 2)))) then
            lines(m)(columns(m) : columns(m) + 8) = " -> cycle"
            columns(m) = columns(m) + 9
         endif
         if (mod (k, 8) .eq. 0) m = m + 1
 1100 continue

C     Print the lines that have stuff in them.
      do 1200 m = 1, 8
         if (columns(m) .ne. 1) then
            write (*, 10000) lines(m)(1 : columns(m) - 1)
         end if
 1200 continue

      end

C-----------------------------------------------------------------------

      function isclos (board)
      implicit none

C     Is a board a closed tour?

      logical isclos
      integer board(1:8,1:8)
      integer ipos(1:64)        ! The i-positions in order.
      integer jpos(1:64)        ! The j-positions in order.
      integer numpos            ! The number of positions so far.

      call bd2pos (board, ipos, jpos, numpos)

      isclos = (numpos .eq. 64 .and.
     $     ((abs (ipos(numpos) - ipos(1)) .eq. 2
     $     .and. abs (jpos(numpos) - jpos(1)) .eq. 1) .or.
     $     ((abs (ipos(numpos) - ipos(1)) .eq. 1
     $     .and. abs (jpos(numpos) - jpos(1)) .eq. 2))))

      end

C-----------------------------------------------------------------------

      subroutine bd2pos (board, ipos, jpos, numpos)
      implicit none

C     Convert from a board to a list of board positions.

      integer board(1:8,1:8)
      integer ipos(1:64)        ! The i-positions in order.
      integer jpos(1:64)        ! The j-positions in order.
      integer numpos            ! The number of positions so far.

      integer i, j

      numpos = 0
      do 1010 i = 1, 8
         do 1000 j = 1, 8
            if (board(i, j) .ne. -1) then
               numpos = max (board(i, j), numpos)
               ipos(board(i, j)) = i
               jpos(board(i, j)) = j
            end if
 1000    continue
 1010 continue

      end

C-----------------------------------------------------------------------

      subroutine nxtmov (board, n, imove, jmove, nmove)
      implicit none

C     Find possible next moves. Prune and sort the moves according to
C     Warnsdorff's heuristic, keeping only those that have the minimum
C     number of legal following moves.

      integer board(1:8,1:8)
      integer n
      integer imove(1:8,1:64)
      integer jmove(1:8,1:64)
      integer nmove(1:64)

      integer w1, w2, w3, w4, w5, w6, w7, w8
      integer w
      integer n1
      integer pickw

      call possib (board, n, imove, jmove, nmove)

      n1 = n + 1
      nmove(n1) = 1
      call countf (board, n1, imove, jmove, nmove, w1)
      nmove(n1) = 2
      call countf (board, n1, imove, jmove, nmove, w2)
      nmove(n1) = 3
      call countf (board, n1, imove, jmove, nmove, w3)
      nmove(n1) = 4
      call countf (board, n1, imove, jmove, nmove, w4)
      nmove(n1) = 5
      call countf (board, n1, imove, jmove, nmove, w5)
      nmove(n1) = 6
      call countf (board, n1, imove, jmove, nmove, w6)
      nmove(n1) = 7
      call countf (board, n1, imove, jmove, nmove, w7)
      nmove(n1) = 8
      call countf (board, n1, imove, jmove, nmove, w8)

      w = pickw (w1, w2, w3, w4, w5, w6, w7, w8)

      if (w .eq. 0) then
         call disabl (imove(1, n1), jmove(1, n1))
         call disabl (imove(2, n1), jmove(2, n1))
         call disabl (imove(3, n1), jmove(3, n1))
         call disabl (imove(4, n1), jmove(4, n1))
         call disabl (imove(5, n1), jmove(5, n1))
         call disabl (imove(6, n1), jmove(6, n1))
         call disabl (imove(7, n1), jmove(7, n1))
         call disabl (imove(8, n1), jmove(8, n1))
      else
         if (w .ne. w1) call disabl (imove(1, n1), jmove(1, n1))
         if (w .ne. w2) call disabl (imove(2, n1), jmove(2, n1))
         if (w .ne. w3) call disabl (imove(3, n1), jmove(3, n1))
         if (w .ne. w4) call disabl (imove(4, n1), jmove(4, n1))
         if (w .ne. w5) call disabl (imove(5, n1), jmove(5, n1))
         if (w .ne. w6) call disabl (imove(6, n1), jmove(6, n1))
         if (w .ne. w7) call disabl (imove(7, n1), jmove(7, n1))
         if (w .ne. w8) call disabl (imove(8, n1), jmove(8, n1))
      end if

      end

C-----------------------------------------------------------------------

      subroutine countf (board, n, imove, jmove, nmove, w)
      implicit none

C     Count the number of moves possible after an nth move.

      integer board(1:8,1:8)
      integer n
      integer imove(1:8,1:64)
      integer jmove(1:8,1:64)
      integer nmove(1:64)
      integer w

      logical goodmv
      integer n1

      if (goodmv (imove, nmove, n)) then
         call mkmove (board, imove, jmove, nmove, n)
         call possib (board, n, imove, jmove, nmove)
         n1 = n + 1
         w = 0
         if (imove(1, n1) .ne. -1) w = w + 1
         if (imove(2, n1) .ne. -1) w = w + 1
         if (imove(3, n1) .ne. -1) w = w + 1
         if (imove(4, n1) .ne. -1) w = w + 1
         if (imove(5, n1) .ne. -1) w = w + 1
         if (imove(6, n1) .ne. -1) w = w + 1
         if (imove(7, n1) .ne. -1) w = w + 1
         if (imove(8, n1) .ne. -1) w = w + 1
         call unmove (board, imove, jmove, nmove, n)
      else
C        The nth move itself is impossible.
         w = 0
      end if

      end

C-----------------------------------------------------------------------

      function pickw (w1, w2, w3, w4, w5, w6, w7, w8)
      implicit none

C     From w1..w8, pick out the least nonzero value (or zero if they all
C     equal zero).

      integer pickw
      integer w1, w2, w3, w4, w5, w6, w7, w8

      integer w
      integer pickw1

      w = 0
      w = pickw1 (w, w1)
      w = pickw1 (w, w2)
      w = pickw1 (w, w3)
      w = pickw1 (w, w4)
      w = pickw1 (w, w5)
      w = pickw1 (w, w6)
      w = pickw1 (w, w7)
      w = pickw1 (w, w8)

      pickw = w

      end

C-----------------------------------------------------------------------

      function pickw1 (u, v)
      implicit none

C     A small function used by pickw.

      integer pickw1
      integer u, v

      if (v .eq. 0) then
         pickw1 = u
      else if (u .eq. 0) then
         pickw1 = v
      else
         pickw1 = min (u, v)
      end if

      end

C-----------------------------------------------------------------------

      subroutine possib (board, n, imove, jmove, nmove)
      implicit none

C     Find moves that are possible from an nth-move position.

      integer board(1:8,1:8)
      integer n
      integer imove(1:8,1:64)
      integer jmove(1:8,1:64)
      integer nmove(1:64)

      integer i, j
      integer n1

      i = imove(nmove(n), n)
      j = jmove(nmove(n), n)
      n1 = n + 1
      call trymov (board, i + 1, j + 2, imove(1, n1), jmove(1, n1))
      call trymov (board, i + 2, j + 1, imove(2, n1), jmove(2, n1))
      call trymov (board, i + 1, j - 2, imove(3, n1), jmove(3, n1))
      call trymov (board, i + 2, j - 1, imove(4, n1), jmove(4, n1))
      call trymov (board, i - 1, j + 2, imove(5, n1), jmove(5, n1))
      call trymov (board, i - 2, j + 1, imove(6, n1), jmove(6, n1))
      call trymov (board, i - 1, j - 2, imove(7, n1), jmove(7, n1))
      call trymov (board, i - 2, j - 1, imove(8, n1), jmove(8, n1))

      end

C-----------------------------------------------------------------------

      subroutine trymov (board, i, j, imove, jmove)
      implicit none

C     Try a move to square (i, j).

      integer board(1:8,1:8)
      integer i, j
      integer imove, jmove

      call disabl (imove, jmove)
      if (1 .le. i .and. i .le. 8 .and. 1 .le. j .and. j .le. 8) then
         if (board(i,j) .eq. -1) then
            call enable (i, j, imove, jmove)
         end if
      end if

      end

C-----------------------------------------------------------------------

      subroutine enable (i, j, imove, jmove)
      implicit none

C     Enable a potential move.

      integer i, j
      integer imove, jmove

      imove = i
      jmove = j

      end

C-----------------------------------------------------------------------

      subroutine disabl (imove, jmove)
      implicit none

C     Disable a potential move.

      integer imove, jmove

      imove = -1
      jmove = -1

      end

C-----------------------------------------------------------------------

      subroutine alg2ij (alg, i, j)
      implicit none

C     Convert, for instance, 'c5' to i=3,j=5.

      character*2 alg
      integer i, j

      if (alg(1:1) .eq. 'a') j = 1
      if (alg(1:1) .eq. 'b') j = 2
      if (alg(1:1) .eq. 'c') j = 3
      if (alg(1:1) .eq. 'd') j = 4
      if (alg(1:1) .eq. 'e') j = 5
      if (alg(1:1) .eq. 'f') j = 6
      if (alg(1:1) .eq. 'g') j = 7
      if (alg(1:1) .eq. 'h') j = 8

      if (alg(2:2) .eq. '1') i = 1
      if (alg(2:2) .eq. '2') i = 2
      if (alg(2:2) .eq. '3') i = 3
      if (alg(2:2) .eq. '4') i = 4
      if (alg(2:2) .eq. '5') i = 5
      if (alg(2:2) .eq. '6') i = 6
      if (alg(2:2) .eq. '7') i = 7
      if (alg(2:2) .eq. '8') i = 8

      end

C-----------------------------------------------------------------------

      subroutine ij2alg (i, j, alg)
      implicit none

C     Convert, for instance, i=3,j=5 to 'c5'.

      integer i, j
      character*2 alg

      character alg1
      character alg2

      if (j .eq. 1) alg1 = 'a'
      if (j .eq. 2) alg1 = 'b'
      if (j .eq. 3) alg1 = 'c'
      if (j .eq. 4) alg1 = 'd'
      if (j .eq. 5) alg1 = 'e'
      if (j .eq. 6) alg1 = 'f'
      if (j .eq. 7) alg1 = 'g'
      if (j .eq. 8) alg1 = 'h'

      if (i .eq. 1) alg2 = '1'
      if (i .eq. 2) alg2 = '2'
      if (i .eq. 3) alg2 = '3'
      if (i .eq. 4) alg2 = '4'
      if (i .eq. 5) alg2 = '5'
      if (i .eq. 6) alg2 = '6'
      if (i .eq. 7) alg2 = '7'
      if (i .eq. 8) alg2 = '8'

      alg(1:1) = alg1
      alg(2:2) = alg2

      end

C-----------------------------------------------------------------------
