def reverseString: explode | reverse | implode;

def levenshteinAlign($x; $y):
  def min($a;$b): [$a,$b]|min;

    ($x|length + 1) as $a1
  | ($y|length + 1) as $b1
  | ($x | ascii_downcase) as $a
  | ($y | ascii_downcase) as $b
  | [range(0; $b1) | 0] as $zeros
  | {costs: [range(0; $a1) | $zeros]}
  | reduce range(0; $b1) as $j (.; .costs[0][$j] = $j)
  | reduce range(1; $a1) as $i (.;
      .costs[$i][0] = $i
      | reduce range(1; $b1) as $j (.;
            (.costs[$i - 1][$j - 1] + (if $a[$i - 1: $i] == $b[$j - 1: $j] then 0 else 1 end)) as $temp
            | .costs[$i][$j] = min( $temp;  1 + min(.costs[$i - 1][$j]; .costs[$i][$j - 1] )) ))

  # walk back through matrix to figure out path
  | .aPathRev = ""
  | .bPathRev = ""
  | .i = ($a|length)
  | .j = ($b|length)
  | until (.i == 0 or .j == 0;
        (.costs[.i - 1][.j - 1] + (if $a[.i - 1: .i] == $b[.j - 1: .j] then 0 else 1 end)) as $temp
        | .costs[.i][.j] as $cij
        | if $cij == $temp
          then .i += -1
          | .aPathRev += $a[.i: .i+1]
          | .j += -1
          | .bPathRev += $b[.j: .j+1]
          elif $cij == 1 + .costs[.i-1][.j]
          then .i += -1
          | .aPathRev += $a[.i:.i+1]
          | .bPathRev += "-"
          elif $cij == 1 + .costs[.i][.j-1]
          then .aPathRev += "-"
          | .j += -1
          | .bPathRev += $b[.j: .j+1]
          end)
   | [.aPathRev, .bPathRev ] | map(reverseString);

levenshteinAlign("place"; "palace"),
levenshteinAlign("rosettacode";"raisethysword")
