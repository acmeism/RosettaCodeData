jq -rn '

  def firstdifferent:
    label $out
    | foreach explode[] as $i ({index:-1};
        .prev = .i | .i = $i | .index +=1;
        if .prev and $i != .prev then .index, break $out else empty end)
      // null ;

  def lpad($n): " "*($n-length) + "\"\(.)\"" ;

  [" "*10, "length", "same", "index", "char"],
  (inputs
   | firstdifferent as $d
   | [lpad(10), length, ($d == null)] + (if $d then [$d, .[$d:$d+1]] else null end) )
  | @tsv
'
