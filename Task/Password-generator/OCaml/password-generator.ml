let lower = "abcdefghijklmnopqrstuvwxyz"
let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let digit = "0123456789"
let other = "!\034#$%&'()*+,-./:;<=>?@[]^_{|}~"

let visually_similar = "Il1O05S2Z"


let mk_pwd len readable =
  let get_char i =
    match i mod 4 with
    | 0 -> lower.[Random.int (String.length lower)]
    | 1 -> upper.[Random.int (String.length upper)]
    | 2 -> digit.[Random.int (String.length digit)]
    | 3 -> other.[Random.int (String.length other)]
    | _ -> raise Exit
  in
  let f =
    if readable then
      (fun i ->
        let rec aux () =
          let c = get_char i in
          if String.contains visually_similar c
          then aux ()
          else (String.make 1 c)
        in
        aux ()
      )
    else
      (fun i ->
        let c = get_char i in
        (String.make 1 c)
      )
  in
  let r = Array.init len f in
  Array.sort (fun _ _ -> (Random.int 3) - 1) r;
  (String.concat "" (Array.to_list r))


let () =
  Random.self_init ();
  let num = ref 1 in
  let len = ref 8 in
  let readable = ref false in
  let speclist = [
    "-n", Arg.Set_int num, "number of passwords";
    "-c", Arg.Set_int len, "number of characters";
    "--readable", Arg.Set readable, "readable";
    "--rand-init", Arg.String (fun s ->
        Random.full_init
          (Array.map int_of_char (Array.of_seq (String.to_seq s)))
      ), "initialise the random generator with a string";
  ] in
  Arg.parse speclist (fun s -> invalid_arg s) "Password generator";
  for i = 1 to !num do
    print_endline (mk_pwd !len !readable)
  done
