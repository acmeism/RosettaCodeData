# If n (the input) is the number of coconuts remaining after
# the surreptitious squirreling away by one sailor,
# then emit the number of coconuts which that sailor originally
# saw if n is admissible, otherwise emit false:
def unsquirrel(sailors):
  if . and (. % (sailors - 1) == 0)
  then 1 + (sailors * (. / (sailors - 1)))
  else false
  end;

# If in the end each sailor received n coconuts (where n is the input), how many coconuts
# were there initially?
def backwards(sailors):
  reduce range(0; sailors) as $i (. * sailors; unsquirrel(sailors));

def solve:
  . as $sailors
  # state: [ final_number_per_sailor, original_number_of_coconuts]
  | [-1] | until( .[1]; .[0] += 1 | .[1] = (.[0] | backwards($sailors)) )
  | "With \($sailors) sailors, there were originally \(.[1]) coconuts,"+
    " and each sailor finally ended up with \(.[0])." ;

range(2;9) | solve
