open Printf;;

let mul3or5 =
   let rec wheel = 3 :: 2 :: 1 :: 3 :: 1 :: 2 :: 3 :: wheel in
      Seq.scan (+) 0 (List.to_seq wheel);;

let sum3or5 upto =
   mul3or5
   |> Seq.take_while (fun n -> n < upto)
   |> Seq.fold_left (+) 0;;

printf "The sum of the multiples of 3 or 5 below 1000 is %d\n" (sum3or5 1000);;
