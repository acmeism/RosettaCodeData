hanoi=: monad define
  moves=. H y
  disks=.  $~` ((],[,]) $:@<:) @.* y
  ('move disk ';' from peg ';' to peg ');@,."1 ":&.>disks,.1+moves
)
