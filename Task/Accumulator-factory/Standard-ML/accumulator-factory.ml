fun accumulator (sum0:real) : real -> real = let
  val sum = ref sum0
  in
    fn n => (
      sum := !sum + n;
      !sum)
  end;

let
  val x = accumulator 1.0
  val _ = x 5.0
  val _ = accumulator 3.0
in
  print (Real.toString (x 2.3) ^ "\n")
end;
