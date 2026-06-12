! Rubik's cube solver translated from Raku.
!
! Representation: 20 pieces (indices 0-11 edges, 12-19 corners).
! Each piece is stored as a string of its sticker face-letters in the
! current orientation, e.g. 'UF', 'DRF'.
!
! Strategy:
!   Phase 1 - Orient : rotate each piece's sticker labels until they
!             match any entry in the goal array, applying a paired
!             algorithm to keep the overall cube state legal.
!   Phase 2 - Permute: cycle misplaced pieces into their correct slots
!             using precomputed algorithms (up to 41 passes).
!
! Algorithm encoding: each character in an algorithm string encodes one
! Rubik's face turn via its ordinal offset (letter - 'A'):
!   offset % 6  -> face  (0=U 1=D 2=F 3=B 4=L 5=R)
!   offset / 6  -> modifier (0='2'  1=' '  2="'"  >=3=no suffix)
! Giving: A-F=double turns, G-L=CW quarter, M-R=CCW quarter, S-X=CW (compact).

program rubics
   implicit none

   integer, parameter :: NPIECES = 20
   integer, parameter :: NALGO   = 38
   integer, parameter :: MLEN    = 20   ! max algorithm string length

   character(len=3)    :: cube(0:NPIECES-1), goal(0:NPIECES-1)
   character(len=MLEN) :: algo(0:NALGO-1)
   character(len=3)    :: tmp
   integer :: total, x, w, rep

   ! Pre-expanded algorithm table derived from Raku's compressed $algo string.
   ! Index 0 is a placeholder (never called). Indices 1-18 are used in the
   ! orient phase; indices 19-37 in the permute phase.
   algo( 0) = 'xILOFCLKHRNQCLx'
   algo( 1) = 'FILOFCLKHRNQCLF'
   algo( 2) = 'DNILOFCLKHRNQCLTD'
   algo( 3) = 'EBILOFCLKHRNQCLBE'
   algo( 4) = 'HILOFCLKHRNQCLN'
   algo( 5) = 'ILOFCLKHRNQCL'
   algo( 6) = 'NILOFCLKHRNQCLT'
   algo( 7) = 'BILOFCLKHRNQCLB'
   algo( 8) = 'RILOFCLKHRNQCLX'
   algo( 9) = 'KBILOFCLKHRNQCLBQ'
   algo(10) = 'LILOFCLKHRNQCLR'
   algo(11) = 'QBILOFCLKHRNQCLBW'
   algo(12) = 'GOBIRALOBIRALM'
   algo(13) = 'AOBIRALOBIRALA'
   algo(14) = 'MOBIRALOBIRALS'
   algo(15) = 'OBIRALOBIRAL'
   algo(16) = 'COBIRALOBIRALC'
   algo(17) = 'IOBIRALOBIRALO'
   algo(18) = 'EOBIRALOBIRALE'
   algo(19) = 'OFICEJHPEIMIGOFU'
   algo(20) = 'DNCEJHPEIMIGTD'
   algo(21) = 'IEOBCEJHPEIMIGBUEO'
   algo(22) = 'HCEJHPEIMIGN'
   algo(23) = 'CEJHPEIMIG'
   algo(24) = 'NCEJHPEIMIGT'
   algo(25) = 'BCEJHPEIMIGB'
   algo(26) = 'GRMCEJHPEIMIGSXM'
   algo(27) = 'MKGBCEJHPEIMIGBMQS'
   algo(28) = 'GLMCEJHPEIMIGSRM'
   algo(29) = 'QBKCEJHPEIMIGQBW'
   algo(30) = 'DFNRHRDKMQ'
   algo(31) = 'DDFNRHRDKMQD'
   algo(32) = 'ENDFNRHRDKMQTE'
   algo(33) = 'EDFNRHRDKMQE'
   algo(34) = 'BDFNRHRDKMQB'
   algo(35) = 'NDFNRHRDKMQT'
   algo(36) = 'DFNRHRDKMQ'
   algo(37) = 'HDFNRHRDKMQN'

   ! Scrambled cube state: position -> sticker labels in current orientation
   cube(0)  = 'UL';  cube(1)  = 'DL';  cube(2)  = 'RF'
   cube(3)  = 'UB';  cube(4)  = 'FD';  cube(5)  = 'BR'
   cube(6)  = 'DB';  cube(7)  = 'UF';  cube(8)  = 'DR'
   cube(9)  = 'UR';  cube(10) = 'BL';  cube(11) = 'FL'
   cube(12) = 'FDR'; cube(13) = 'BLU'; cube(14) = 'DLB'
   cube(15) = 'URB'; cube(16) = 'RUF'; cube(17) = 'FLD'
   cube(18) = 'BRD'; cube(19) = 'FUL'

   ! Solved goal state: position -> canonical sticker labels
   goal(0)  = 'UF';  goal(1)  = 'UR';  goal(2)  = 'UB'
   goal(3)  = 'UL';  goal(4)  = 'DF';  goal(5)  = 'DR'
   goal(6)  = 'DB';  goal(7)  = 'DL';  goal(8)  = 'FR'
   goal(9)  = 'FL';  goal(10) = 'BR';  goal(11) = 'BL'
   goal(12) = 'UFR'; goal(13) = 'URB'; goal(14) = 'UBL'
   goal(15) = 'ULF'; goal(16) = 'DRF'; goal(17) = 'DFL'
   goal(18) = 'DLB'; goal(19) = 'DBR'

   total = 0

   ! Phase 1 - Orient: for each piece 1..18, apply algorithm x until the
   ! piece's sticker label string appears somewhere in the goal array.
   ! Piece 0 (edge) or 19 (corner) absorbs the complementary orientation
   ! change to maintain the cube's orientation parity invariant.
   do x = 1, 18
      do while (.not. in_goal(cube(x), goal))
         total = total + print_alg(x, algo)
         cube(x) = rotate_left(cube(x))
         if (x < 12) then
            cube(0)  = rotate_right(cube(0))
         else
            cube(19) = rotate_right(cube(19))
         end if
      end do
   end do

   ! Phase 2 - Permute: scan all 20 positions each pass; when a piece is
   ! misplaced find which goal slot it belongs to (position x), cycle it
   ! home with the matching permutation algorithm, then restart the scan.
   ! 41 passes suffice for this particular scramble.
   do rep = 1, 41
      do w = 0, 19
         if (cube(w) == goal(w)) cycle
         ! Find x: the goal slot whose label matches the piece at slot w
         x = 0
         do while (cube(w) /= goal(x))
            x = x + 1
         end do
         if (x < 12) then
            ! Simultaneously swap cube(0)<->cube(x) and cube(12)<->cube(15)
            tmp = cube(0);  cube(0)  = cube(x);  cube(x)  = tmp
            tmp = cube(12); cube(12) = cube(15); cube(15) = tmp
         else
            ! Swap cube(12)<->cube(x)
            tmp = cube(12); cube(12) = cube(x); cube(x) = tmp
         end if
         total = total + print_alg(x + 18, algo)
         exit
      end do
   end do

   write(*, *)
   write(*, '(A,I0)') 'Total number of moves : ', total

contains

   ! Return true if piece matches any entry in goal_arr.
   logical function in_goal(piece, goal_arr)
      character(len=*), intent(in) :: piece
      character(len=3), intent(in) :: goal_arr(0:NPIECES-1)
      integer :: i
      in_goal = .false.
      do i = 0, NPIECES - 1
         if (piece == goal_arr(i)) then
            in_goal = .true.
            return
         end if
      end do
   end function in_goal

   ! Cycle first character to end: "ABC" -> "BCA"
   function rotate_left(s) result(r)
      character(len=*), intent(in) :: s
      character(len=len(s)) :: r
      integer :: n
      n = len_trim(s)
      if (n <= 1) then
         r = s
      else
         r(1:n-1) = s(2:n)
         r(n:n)   = s(1:1)
         if (n < len(s)) r(n+1:) = ' '
      end if
   end function rotate_left

   ! Cycle last character to front: "ABC" -> "CAB"
   function rotate_right(s) result(r)
      character(len=*), intent(in) :: s
      character(len=len(s)) :: r
      integer :: n
      n = len_trim(s)
      if (n <= 1) then
         r = s
      else
         r(1:1)   = s(n:n)
         r(2:n)   = s(1:n-1)
         if (n < len(s)) r(n+1:) = ' '
      end if
   end function rotate_right

   ! Decode algorithm at algo_arr(idx), print its Rubik's move sequence,
   ! and return the number of moves.
   !
   ! Each letter encodes one move:
   !   ord = iachar(letter) - 65
   !   face     = "UDFBLR"(ord%6 + 1)
   !   modifier: ord/6=0 -> '2',  ord/6=1 -> ' ',  ord/6=2 -> "'",  ord/6>=3 -> ''
   integer function print_alg(idx, algo_arr)
      integer,             intent(in) :: idx
      character(len=MLEN), intent(in) :: algo_arr(0:NALGO-1)
      character(len=6), parameter :: faces = 'UDFBLR'
      integer :: i, n, ord, fi, mi
      character(len=300) :: out

      n   = len_trim(algo_arr(idx))
      out = ''
      do i = 1, n
         ord = iachar(algo_arr(idx)(i:i)) - 65
         fi  = mod(ord, 6)
         mi  = ord / 6
         out = trim(out) // faces(fi+1:fi+1)
         select case (mi)
         case (0); out = trim(out) // '2'
         case (1); out = trim(out) // ' '
         case (2); out = trim(out) // "'"
         end select
      end do
      write(*, '(A)') trim(out)
      print_alg = n
   end function print_alg

end program rubics
