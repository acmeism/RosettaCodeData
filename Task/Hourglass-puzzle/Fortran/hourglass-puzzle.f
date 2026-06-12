program timer
  implicit none

  integer, parameter :: NCOLS = 4
  integer, parameter :: NROWS = 5   ! header + 5 data rows = 6 lines total

  ! Column widths (excluding border characters)
  integer, parameter :: W1 =  8   ! Time Elapsed
  integer, parameter :: W2 = 38   ! Action on 4-min hourglass
  integer, parameter :: W3 = 48   ! Action on 7-min hourglass
  integer, parameter :: W4 = 52   ! What's happening

  character(len=W1)  :: c1
  character(len=W2)  :: c2
  character(len=W3)  :: c3
  character(len=W4)  :: c4

  call hline(W1, W2, W3, W4)
  call row('Time    ', &
           'Action on 4-min hourglass             ', &
           'Action on 7-min hourglass               ', &
           'What''s happening / Sand remaining       ')
  call hline(W1, W2, W3, W4)

  call row('0:00    ', &
           'Flip (start)                          ', &
           'Flip (start)                            ', &
           'Both running from full                  ')

  call hline(W1, W2, W3, W4)

  call row('4:00    ', &
           'Runs out -> Flip it (starts again)    ', &
           'Still running (3 min left in top)       ', &
           '4-min restarts; 7-min has 3 min left   ')

  call hline(W1, W2, W3, W4)

  call row('7:00    ', &
           'Has run 3 min -> 1 min left in top    ', &
           'Runs out -> Flip it (starts full 7 min) ', &
           'Flip the 7-min; let 4-min continue      ')

  call hline(W1, W2, W3, W4)

  call row('8:00    ', &
           'Runs out (its remaining 1 min done)   ', &
           'Has run 1 min -> Flip it                ', &
           '7-min now has 1 min of sand in top      ')

  call hline(W1, W2, W3, W4)

  call row('9:00    ', &
           '(Not needed)                          ', &
           'Runs out                                ', &
           'Exactly 9 minutes have passed           ')

  call hline(W1, W2, W3, W4)

contains

  subroutine row(a, b, c, d)
    character(len=W1), intent(in) :: a
    character(len=W2), intent(in) :: b
    character(len=W3), intent(in) :: c
    character(len=W4), intent(in) :: d
    write(*,'(A,A,A,A,A,A,A,A,A)') '| ', a, ' | ', b, ' | ', c, ' | ', d, ' |'
  end subroutine row

  subroutine hline(w1, w2, w3, w4)
    integer, intent(in) :: w1, w2, w3, w4
    character(len=200) :: line
    integer :: pos, i

    pos = 1
    line(pos:pos) = '+'
    pos = pos + 1
    do i = 1, w1 + 2
      line(pos:pos) = '-'
      pos = pos + 1
    end do
    line(pos:pos) = '+'
    pos = pos + 1
    do i = 1, w2 + 2
      line(pos:pos) = '-'
      pos = pos + 1
    end do
    line(pos:pos) = '+'
    pos = pos + 1
    do i = 1, w3 + 2
      line(pos:pos) = '-'
      pos = pos + 1
    end do
    line(pos:pos) = '+'
    pos = pos + 1
    do i = 1, w4 + 2
      line(pos:pos) = '-'
      pos = pos + 1
    end do
    line(pos:pos) = '+'
    pos = pos + 1
    write(*,'(A)') trim(line(1:pos-1))
  end subroutine hline

end program timer


