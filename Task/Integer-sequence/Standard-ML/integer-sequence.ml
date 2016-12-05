let
  fun printInts(n) =
    (		
      print(Int.toString(n) ^ "\n");
      printInts(n+1)
    )
in
  printInts(1)
end;
