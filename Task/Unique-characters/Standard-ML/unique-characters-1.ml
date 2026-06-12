fun uniqueChars xs =
  let
    val arr = Array.array(256, 0)
    val inc = (fn c => Array.update(arr, ord c, Array.sub(arr, ord c)+1))
    val _ = List.app inc (List.concat (List.map String.explode xs))
    val ex1 = (fn (i,n,a) => if n=1 then (chr i)::a else a)
  in
    String.implode (Array.foldri ex1 [] arr)
  end
