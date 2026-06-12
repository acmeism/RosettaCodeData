let has_adjacent n x =
  let rec loop c = function
     h :: t when h = x -> loop (c+1) t
    |_ :: t -> c = n || loop 0 t
    |_ -> c = n
  in loop 0
[[9;3;3;3;2;1;7;8;5];[5;2;9;3;3;7;8;4;1];[1;4;3;6;7;3;8;3;2];[1;2;3;4;5;6;7;8;9];[4;6;8;7;2;3;3;3;1]]|>List.iter((has_adjacent 3 3)>>printfn "%A")
