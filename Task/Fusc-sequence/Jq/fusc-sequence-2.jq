# Save space by truncating the beginning of the array
def fusc:
   0, 1,
   foreach range(2; infinite) as $n ([0, 1];
      ($n % 2 == 0) as $even
      | if $even then . + [.[1]] else.[1:] + [.[1] + .[2]] end;
      .[-1] );

# Report first longest
def fusc( $mx ):
  def l: commatize|lpad(10);

  foreach limit( $mx; fusc ) as $f ({ maxLen: 0, n: 0 };
    .emit = false
    | ("\($f)"|length) as $len
    | if $len > .maxLen
      then .maxLen = $len
      | .emit = "\(.n|l)  \($f|commatize)"
      else .
      end
      | .n += 1
      ;
      select(.emit).emit
    );

# First $first numbers in the fusc sequence
61 as $first
| 2e6 as $mx
| "The first \($first) numbers in the fusc sequence are:",
   ([limit($first; fusc)]| map(tostring) | join(" ")) ,

   "\nFirst terms longer than any previous ones for indices < \($mx + 0 |commatize):",
   "     Index  Value",
   fusc($mx)
