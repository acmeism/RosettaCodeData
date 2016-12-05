open Pcre

let lookandsay str =
  let rex = regexp "(.)\\1*" in
  let subs = exec_all ~rex str in
  let ar = Array.map (fun sub -> get_substring sub 0) subs in
  let ar = Array.map (fun s -> String.length s, s.[0]) ar in
  let ar = Array.map (fun (n,c) -> (string_of_int n) ^ (String.make 1 c)) ar in
  let res = String.concat "" (Array.to_list ar) in
  (res)

let () =
  let num = ref(string_of_int 1) in
  for i = 1 to 10 do
    num := lookandsay !num;
    print_endline !num;
  done
