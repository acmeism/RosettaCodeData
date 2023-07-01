#-----------------------------------------------------------------------
#
#     Find Knight’s Tours.
#
#     Using Warnsdorff’s heuristic, find multiple solutions.
#     Optionally accept only closed tours.
#
#     This program is migrated from my implementation for ATS/Postiats.
#     Arrays with dimension 1:64 take the place of stack frames.
#
#     Compile with, for instance:
#
#         ratfor77 knights_tour.r > knights_tour.f
#         gfortran -O2 -g -std=legacy -o knights_tour knights_tour.f
#
#     or
#
#         ratfor77 knights_tour.r > knights_tour.f
#         f2c knights_tour.f
#         cc -O -o knights_tour knights_tour.c -lf2c
#
#     Usage examples:
#
#         One tour starting at a1, either open or closed:
#
#            echo "a1 1 F" | ./knights_tour
#
#         No more than 2000 closed tours starting at c5:
#
#            echo "c5 2000 T" | ./knights_tour
#
#-----------------------------------------------------------------------

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

#-----------------------------------------------------------------------

subroutine explor (istart, jstart, mxtour, closed)
implicit none

# Explore the space of 'Warnsdorffian' knight’s paths, looking for
# and printing complete tours.

integer istart, jstart    # The starting position.
integer mxtour            # The maximum number of tours to print.
logical closed            # Closed tours only?

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

while (itours < mxtour && n != 0) {
  if (nmove(n) == 9) {
    n = n - 1
    if (n != 0) {
      call unmove (board, imove, jmove, nmove, n)
      nmove(n) = nmove(n) + 1
    }
  } else if (goodmv (imove, nmove, n)) {
    call mkmove (board, imove, jmove, nmove, n)
    if (n == 64) {
      if (.not. closed) {
        itours = itours + 1
        call prnt (board, itours)
      } else if (isclos (board)) {
        itours = itours + 1
        call prnt (board, itours)
      }
      call unmove (board, imove, jmove, nmove, n)
      nmove(n) = 9
    } else if (n == 63) {
      call possib (board, n, imove, jmove, nmove)
      n = n + 1
      nmove(n) = 1
    } else {
      call nxtmov (board, n, imove, jmove, nmove)
      n = n + 1
      nmove(n) = 1
    }
  } else {
    nmove(n) = nmove(n) + 1
  }
}

end

#-----------------------------------------------------------------------

subroutine initbd (board)
implicit none

# Initialize a chessboard with empty squares.

integer board(1:8,1:8)

integer i, j

do j = 1, 8 {
  do i = 1, 8 {
    board(i, j) = -1
  }
}

end

#-----------------------------------------------------------------------

subroutine mkmove (board, imove, jmove, nmove, n)
implicit none

# Fill a square with a move number.

integer board(1:8, 1:8)
integer imove(1:8, 1:64)
integer jmove(1:8, 1:64)
integer nmove(1:64)
integer n

board(imove(nmove(n), n), jmove(nmove(n), n)) = n

end

#-----------------------------------------------------------------------

subroutine unmove (board, imove, jmove, nmove, n)
implicit none

# Unmake a mkmove.

integer board(1:8, 1:8)
integer imove(1:8, 1:64)
integer jmove(1:8, 1:64)
integer nmove(1:64)
integer n

board(imove(nmove(n), n), jmove(nmove(n), n)) = -1

end

#-----------------------------------------------------------------------

function goodmv (imove, nmove, n)
implicit none

logical goodmv
integer imove(1:8, 1:64)
integer nmove(1:64)
integer n

goodmv = (imove(nmove(n), n) != -1)

end

#-----------------------------------------------------------------------

subroutine prnt (board, itours)
implicit none

# Print a knight's tour.

integer board(1:8,1:8)
integer itours

10000 format (1X)

# The following plethora of format statements seemed a simple way to
# get this working with f2c. (For gfortran, the 'I0' format
# sufficed.)
10010 format (1X, "Tour number ", I1)
10020 format (1X, "Tour number ", I2)
10030 format (1X, "Tour number ", I3)
10040 format (1X, "Tour number ", I4)
10050 format (1X, "Tour number ", I5)
10060 format (1X, "Tour number ", I6)
10070 format (1X, "Tour number ", I20)

if (itours < 10) {
  write (*, 10010) itours
} else if (itours < 100) {
  write (*, 10020) itours
} else if (itours < 1000) {
  write (*, 10030) itours
} else if (itours < 10000) {
  write (*, 10040) itours
} else if (itours < 100000) {
  write (*, 10050) itours
} else if (itours < 1000000) {
  write (*, 10060) itours
} else {
  write (*, 10070) itours
}
call prntmv (board)
call prntbd (board)
write (*, 10000)

end

#-----------------------------------------------------------------------

subroutine prntbd (board)
implicit none

# Print a chessboard with the move number in each square.

integer board(1:8,1:8)

integer i, j

10000 format (1X, "    ", 8("+----"), "+")
10010 format (1X, I2, " ", 8(" | ", I2), " | ")
10020 format (1X, "   ", 8("    ", A1))

do i = 8, 1, -1 {
  write (*, 10000)
  write (*, 10010) i, (board(i, j), j = 1, 8)
}
write (*, 10000)
write (*, 10020) 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'

end

#-----------------------------------------------------------------------

subroutine prntmv (board)
implicit none

# Print the moves of a knight's path, in algebraic notation.

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

# Convert the positions to algebraic notation.
do k = 1, numpos {
  call ij2alg (ipos(k), jpos(k), alg(k))
}

# Fill lines with algebraic notations.
do m = 1, 8 {
  columns(m) = 1
}
m = 1
do k = 1, numpos {
   lines(m)(columns(m) : columns(m) + 1) = alg(k)(1:2)
   columns(m) = columns(m) + 2
   if (k != numpos) {
     lines(m)(columns(m) : columns(m) + 3) = " -> "
     columns(m) = columns(m) + 4
   } else if (numpos == 64 &&                                    _
              ((abs (ipos(numpos) - ipos(1)) == 2                _
                 && abs (jpos(numpos) - jpos(1)) == 1)           _
               || ((abs (ipos(numpos) - ipos(1)) == 1            _
                     && abs (jpos(numpos) - jpos(1)) == 2)))) {
      lines(m)(columns(m) : columns(m) + 8) = " -> cycle"
      columns(m) = columns(m) + 9
   }
   if (mod (k, 8) == 0) m = m + 1
}

# Print the lines that have stuff in them.
do m = 1, 8 {
  if (columns(m) != 1) {
    write (*, 10000) lines(m)(1 : columns(m) - 1)
  }
}

end

#-----------------------------------------------------------------------

function isclos (board)
implicit none

# Is a board a closed tour?

logical isclos
integer board(1:8,1:8)
integer ipos(1:64)        # The i-positions in order.
integer jpos(1:64)        # The j-positions in order.
integer numpos            # The number of positions so far.

call bd2pos (board, ipos, jpos, numpos)

isclos = (numpos == 64 &&                                   _
          ((abs (ipos(numpos) - ipos(1)) == 2               _
             && abs (jpos(numpos) - jpos(1)) == 1)          _
            || ((abs (ipos(numpos) - ipos(1)) == 1          _
                  && abs (jpos(numpos) - jpos(1)) == 2))))

end

#-----------------------------------------------------------------------

subroutine bd2pos (board, ipos, jpos, numpos)
implicit none

# Convert from a board to a list of board positions.

integer board(1:8,1:8)
integer ipos(1:64)        # The i-positions in order.
integer jpos(1:64)        # The j-positions in order.
integer numpos            # The number of positions so far.

integer i, j

numpos = 0
do i = 1, 8 {
  do j = 1, 8 {
    if (board(i, j) != -1) {
      numpos = max (board(i, j), numpos)
      ipos(board(i, j)) = i
      jpos(board(i, j)) = j
    }
  }
}

end

#-----------------------------------------------------------------------

subroutine nxtmov (board, n, imove, jmove, nmove)
implicit none

# Find possible next moves. Prune and sort the moves according to
# Warnsdorff's heuristic, keeping only those that have the minimum
# number of legal following moves.

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

if (w == 0) {
  call disabl (imove(1, n1), jmove(1, n1))
  call disabl (imove(2, n1), jmove(2, n1))
  call disabl (imove(3, n1), jmove(3, n1))
  call disabl (imove(4, n1), jmove(4, n1))
  call disabl (imove(5, n1), jmove(5, n1))
  call disabl (imove(6, n1), jmove(6, n1))
  call disabl (imove(7, n1), jmove(7, n1))
  call disabl (imove(8, n1), jmove(8, n1))
} else {
  if (w != w1) call disabl (imove(1, n1), jmove(1, n1))
  if (w != w2) call disabl (imove(2, n1), jmove(2, n1))
  if (w != w3) call disabl (imove(3, n1), jmove(3, n1))
  if (w != w4) call disabl (imove(4, n1), jmove(4, n1))
  if (w != w5) call disabl (imove(5, n1), jmove(5, n1))
  if (w != w6) call disabl (imove(6, n1), jmove(6, n1))
  if (w != w7) call disabl (imove(7, n1), jmove(7, n1))
  if (w != w8) call disabl (imove(8, n1), jmove(8, n1))
}

end

#-----------------------------------------------------------------------

subroutine countf (board, n, imove, jmove, nmove, w)
implicit none

# Count the number of moves possible after an nth move.

integer board(1:8,1:8)
integer n
integer imove(1:8,1:64)
integer jmove(1:8,1:64)
integer nmove(1:64)
integer w

logical goodmv
integer n1

if (goodmv (imove, nmove, n)) {
  call mkmove (board, imove, jmove, nmove, n)
  call possib (board, n, imove, jmove, nmove)
  n1 = n + 1
  w = 0
  if (imove(1, n1) != -1) w = w + 1
  if (imove(2, n1) != -1) w = w + 1
  if (imove(3, n1) != -1) w = w + 1
  if (imove(4, n1) != -1) w = w + 1
  if (imove(5, n1) != -1) w = w + 1
  if (imove(6, n1) != -1) w = w + 1
  if (imove(7, n1) != -1) w = w + 1
  if (imove(8, n1) != -1) w = w + 1
  call unmove (board, imove, jmove, nmove, n)
} else {
  # The nth move itself is impossible.
  w = 0
}

end

#-----------------------------------------------------------------------

function pickw (w1, w2, w3, w4, w5, w6, w7, w8)
implicit none

# From w1..w8, pick out the least nonzero value (or zero if they all
# equal zero).

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

#-----------------------------------------------------------------------

function pickw1 (u, v)
implicit none

# A small function used by pickw.

integer pickw1
integer u, v

if (v == 0) {
  pickw1 = u
} else if (u == 0) {
  pickw1 = v
} else {
  pickw1 = min (u, v)
}

end

#-----------------------------------------------------------------------

subroutine possib (board, n, imove, jmove, nmove)
implicit none

# Find moves that are possible from an nth-move position.

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

#-----------------------------------------------------------------------

subroutine trymov (board, i, j, imove, jmove)
implicit none

# Try a move to square (i, j).

integer board(1:8,1:8)
integer i, j
integer imove, jmove

call disabl (imove, jmove)
if (1 <= i && i <= 8 && 1 <= j && j <= 8) {
  if (board(i,j) == -1) {
    call enable (i, j, imove, jmove)
  }
}

end

#-----------------------------------------------------------------------

subroutine enable (i, j, imove, jmove)
implicit none

# Enable a potential move.

integer i, j
integer imove, jmove

imove = i
jmove = j

end

#-----------------------------------------------------------------------

subroutine disabl (imove, jmove)
implicit none

# Disable a potential move.

integer imove, jmove

imove = -1
jmove = -1

end

#-----------------------------------------------------------------------

subroutine alg2ij (alg, i, j)
implicit none

# Convert, for instance, 'c5' to i=3,j=5.

character*2 alg
integer i, j

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

end

#-----------------------------------------------------------------------

subroutine ij2alg (i, j, alg)
implicit none

# Convert, for instance, i=3,j=5 to 'c5'.

integer i, j
character*2 alg

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

end

#-----------------------------------------------------------------------
