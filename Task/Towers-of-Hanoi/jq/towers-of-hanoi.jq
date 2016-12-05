# n is the number of disks to move from From to To
def move(n; From; To; Via):
  if n > 0 then
     # move all but the largest at From to Via (according to the rules):
     move(n-1; From; Via; To),
     # ... so the largest disk at From is now free to move to its final destination:
     "Move disk from \(From) to \(To)",
     # Move the remaining disks at Via to To:
     move(n-1; Via; To; From)
  else empty
  end;
