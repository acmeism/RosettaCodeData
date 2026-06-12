(*
  group [1,1,2,4,4,4,2,2,2,1,1,1,3]
  => [[1,1], [2], [4,4,4], [2,2,2], [1,1,1], [3]]
*)
fun group xs =
  let
    fun collectGroups(a,[]) = [[a]]
      | collectGroups(a,b::bs) = if a = (hd b) then (a::b)::bs else [a]::b::bs
  in
    List.foldr collectGroups [] xs
  end

fun uniqueChars2 xs =
  let
    (* turn the strings into one big list of characters *)
    val cs = List.concat (List.map String.explode xs)
    (* sort the big list of characters *)
    val scs = ListMergeSort.sort Char.> cs
    (* collect the groups *)
    val gs = group scs
    (* filter out groups with more than one member *)
    val os = List.filter (fn a => null (tl a)) gs
  in
    String.implode (List.concat os)
  end
