fun printIntList ls =
  (
    List.app (fn n => print(Int.toString n ^ " ")) ls;
    print "\n"
  );

fun factors n =
  let
    fun factors'(n, k) =
      if k > n then
        []
      else if n mod k = 0 then
        k :: factors'(n, k+1)
      else
        factors'(n, k+1)
  in
    factors'(n,1)
  end;
