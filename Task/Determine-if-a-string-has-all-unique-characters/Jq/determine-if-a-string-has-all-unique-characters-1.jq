# Emit null if there is no duplicate, else [c, [ix1, ix2]]
def firstDuplicate:
  label $out
  | foreach explode[] as $i ({ix: -1};
    .ix += 1
    | .ix as $ix
    | .iu = ([$i] | implode)
    | .[.iu] += [ $ix] ;
    if .[.iu]|length == 2 then [.iu, .[.iu]], break $out else empty end )
    // null ;
