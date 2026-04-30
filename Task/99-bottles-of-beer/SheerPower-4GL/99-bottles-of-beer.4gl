declare integer n%

for n% = 99 to 1 step -1
  print bottles$(n%); ' of beer on the wall, '; bottles$(n%); ' of beer.'
  print 'Take one down and pass it around, '; bottles$(n% - 1); ' of beer on the wall.'
  print
next n%

print 'No more bottles of beer on the wall, no more bottles of beer.'
print 'Go to the store and buy some more, 99 bottles of beer on the wall.'

! =============================================================================
! Routine: bottles$(n%)
!
! Return the correct phrase for n% bottles:
!   0        → "no more bottles"
!   1        → "1 bottle"
!   2 or more → "<n> bottles"
! =============================================================================
routine bottles$(n%)
  if n% = 0 then
    bottles$ = 'no more bottles'
  elseif n% = 1 then
    bottles$ = '1 bottle'
  else
    bottles$ = str$(n%) + ' bottles'
  end if
end routine
