program smith_waterman_correct
  implicit none

  character(*), parameter :: seq1 = "Oh say can you see by the dawn's early light"
  character(*), parameter :: seq2 = "dawn@s"
  integer, parameter      :: m = len(seq1), n = len(seq2)
  integer                 :: H(0:m, 0:n)
  integer                 :: i, j, diag, up, left, score
  integer                 :: max_val = 0, max_i = 0, max_j = 0
  character(100)          :: align1 = "", align2 = ""
  integer, parameter      :: match_score = 2, mismatch = -1, gap = -2

  ! Initialize matrix
  H = 0

  ! Fill DP table
  do i = 1, m
    do j = 1, n
      if (seq1(i:i) == seq2(j:j)) then
        diag = H(i-1,j-1) + match_score
      else
        diag = H(i-1,j-1) + mismatch
      end if
      up   = H(i-1,j) + gap
      left = H(i,j-1) + gap

      H(i,j) = max(0, diag, up, left)

      if (H(i,j) > max_val) then
        max_val = H(i,j)
        max_i = i
        max_j = j
      end if
    end do
  end do

  ! Traceback from maximum value
  i = max_i
  j = max_j

  do while (H(i,j) > 0)
    if (i > 0 .and. j > 0 .and. &
        H(i,j) == H(i-1,j-1) + merge(match_score, mismatch, seq1(i:i) == seq2(j:j))) then
      align1 = seq1(i:i) // align1
      align2 = seq2(j:j) // align2
      i = i - 1
      j = j - 1
    else if (i > 0 .and. H(i,j) == H(i-1,j) + gap) then
      align1 = seq1(i:i) // align1
      align2 = "-" // align2
      i = i - 1
    else if (j > 0 .and. H(i,j) == H(i,j-1) + gap) then
      align1 = "-" // align1
      align2 = seq2(j:j) // align2
      j = j - 1
    else
      exit
    end if
  end do

  print "(a,i0)", "Highest alignment score: ", max_val
  print "(a)",    "Sequence 1 substring:  " // trim(align1)
  print "(a)",    "Sequence 2 substring:  " // trim(align2)
  print "(a)",    "Alignment:"
  print "(a)",    "  " // align1
  print "(a)",    "  " // align2

end program
