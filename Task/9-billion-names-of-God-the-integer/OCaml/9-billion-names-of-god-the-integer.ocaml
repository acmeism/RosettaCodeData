let get, sum_unto =
  let cache = ref [||]
  let rec get i j =
    if Array.length !cache < i then
      cache :=
        Array.init i begin fun i ->
          try !cache.(i) with Invalid_argument _ ->
          Array.make (i+1) (Num.num_of_int 0)
        end;
    if Num.(!cache.(i-1).(j-1) =/ num_of_int 0)
    then !cache.(i-1).(j-1) <- sum_unto (i-j) j;
    !cache.(i-1).(j-1)
  and sum_unto i j =
    let rec sum_unto sum i j =
      match (i,j) with
      |(0,0) -> (Num.num_of_int 1)
      |(_,0) -> sum
      |(i,j) when j > i -> sum_unto sum i i
      |(i,j) -> sum_unto Num.(sum +/ (get i j)) i (j-1)
    in
    sum_unto (Num.num_of_int 0) i j
  in
  get, sum_unto

let sum_of_row n = sum_unto n n

let euler_recurrence =
  let cache = ref [||] in
  let rec recurrence = function
    |n when n < 0 -> Num.num_of_int 0
    |0 -> Num.num_of_int 1
    |n ->
        if n >= Array.length !cache then
          cache :=
            Array.init (n+1) (fun i ->
              try !cache.(i) with Invalid_argument _ -> Num.num_of_int 0);
        if Num.(!cache.(n) =/ num_of_int 0)
        then begin
          let rec summing sum = function
            |0 -> sum
            |k ->
                let op = if k mod 2 = 0 then Num.sub_num else Num.add_num in
                let sum = op sum (recurrence (n - k * (3*k - 1) / 2)) in
                let sum = op sum (recurrence (n - k * (3*k + 1) / 2)) in
                summing sum (k-1)
          in
          !cache.(n) <- summing (Num.num_of_int 0) n
        end;
        !cache.(n)
  in
  recurrence

let print i_max =
  for i=1 to i_max do
    print_int (i+1); print_string ": ";
    for j=1 to i do
      print_string (Num.string_of_num (get i j));
      print_char ' ';
    done;
    print_newline ();
  done

let () =
  print 30;
  print_newline ();
  List.iter begin fun i ->
      Printf.printf "%i: %s ?= %s\n" i
        (Num.string_of_num (sum_of_row i))
        (Num.string_of_num (euler_recurrence i));
      flush stdout;
    end
  [23;123;1234;];
  List.iter begin fun i ->
      Printf.printf "%i: %s\n" i
        (Num.string_of_num (euler_recurrence i));
      flush stdout;
    end
  [23;123;1234;12345;123456]
