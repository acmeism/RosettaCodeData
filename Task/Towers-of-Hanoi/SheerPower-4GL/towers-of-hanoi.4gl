declare integer discs%

discs% = 4
print 'Tower of Hanoi — '; discs%; ' discs'
print 'Minimum moves: '; 2 ^ discs% - 1
print

call hanoi(discs%, 'A', 'C', 'B')

! =============================================================================
! Routine: hanoi(n%, from$, to$, via$)
!
! Move n% discs from peg from$ to peg to$, using peg via$ as auxiliary.
! Prints each move as "Move disc N from X to Y".
! =============================================================================
routine hanoi(n%, from$, to$, via$)
  if n% > 0 then
    call hanoi(n% - 1, from$, via$, to$)
    print 'Move disc '; n%; ' from '; from$; ' to '; to$
    call hanoi(n% - 1, via$, to$, from$)
  end if
end routine
