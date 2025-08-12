open Printf

(* Custom exception for invalid addresses *)
exception Invalid_address of string

(* Helper functions for string parsing *)
let is_digit c = c >= '0' && c <= '9'
let is_hex_digit c = is_digit c || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')

let split_string s delimiter =
  let len = String.length s in
  let rec aux acc start i =
    if i >= len then
      if start < len then (String.sub s start (len - start)) :: acc
      else acc
    else if s.[i] = delimiter then
      let part = String.sub s start (i - start) in
      aux (part :: acc) (i + 1) (i + 1)
    else
      aux acc start (i + 1)
  in
  List.rev (aux [] 0 0)

let string_contains s substr =
  let s_len = String.length s in
  let substr_len = String.length substr in
  let rec aux i =
    if i > s_len - substr_len then false
    else if String.sub s i substr_len = substr then true
    else aux (i + 1)
  in
  if substr_len = 0 then true else aux 0

(* Check if string contains only digits *)
let is_numeric s =
  let len = String.length s in
  len > 0 &&
  let rec aux i =
    if i >= len then true
    else if is_digit s.[i] then aux (i + 1)
    else false
  in
  aux 0

(* Check if string contains only hex digits *)
let is_hex s =
  let len = String.length s in
  len > 0 &&
  let rec aux i =
    if i >= len then true
    else if is_hex_digit (Char.lowercase_ascii s.[i]) then aux (i + 1)
    else false
  in
  aux 0

(* Convert decimal string to 2-digit hex for IPv4 *)
let to_hex4 s =
  if not (is_numeric s) then
    raise (Invalid_address ("ERROR 101: Invalid value : " ^ s));
  let val_int = int_of_string s in
  if val_int < 0 || val_int > 255 then
    raise (Invalid_address ("ERROR 101: Invalid value : " ^ s))
  else
    Printf.sprintf "%02x" val_int

(* Validate and return hex string for IPv6 *)
let to_hex6 s =
  if not (is_hex s) then
    raise (Invalid_address ("ERROR 102: Invalid hex value : " ^ s));
  let val_int = int_of_string ("0x" ^ s) in
  if val_int < 0 || val_int > 65535 then
    raise (Invalid_address ("ERROR 102: Invalid hex value : " ^ s))
  else
    s

(* Parse IPv4 address *)
let parse_ipv4 ip =
  let parts = split_string ip '.' in
  match parts with
  | [p1; p2; p3; p4_port] ->
    (* Check if last part has port *)
    if string_contains p4_port ":" then
      let port_parts = split_string p4_port ':' in
      (match port_parts with
       | [p4; port] when is_numeric p4 && is_numeric port ->
         let hex = (to_hex4 p1) ^ (to_hex4 p2) ^ (to_hex4 p3) ^ (to_hex4 p4) in
         (hex, port)
       | _ -> raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip)))
    else if is_numeric p4_port then
      let hex = (to_hex4 p1) ^ (to_hex4 p2) ^ (to_hex4 p3) ^ (to_hex4 p4_port) in
      (hex, "")
    else
      raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip))
  | _ -> raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip))

(* Parse IPv6 address *)
let parse_ipv6 ip =
  let (clean_ip, port) =
    if String.length ip > 0 && ip.[0] = '[' then
      (* Bracketed IPv6 with possible port *)
      try
        let bracket_end = String.index ip ']' in
        let addr_part = String.sub ip 1 (bracket_end - 1) in
        if bracket_end + 1 < String.length ip && ip.[bracket_end + 1] = ':' then
          let port_part = String.sub ip (bracket_end + 2) (String.length ip - bracket_end - 2) in
          (addr_part, port_part)
        else
          (addr_part, "")
      with Not_found ->
        raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip))
    else
      (ip, "") in

  (* Handle double colon expansion *)
  let expanded_ip =
    if string_contains clean_ip "::" then
      (* Split on :: to get before and after parts *)
      let double_colon_pos =
        let rec find_pos i =
          if i >= String.length clean_ip - 1 then -1
          else if clean_ip.[i] = ':' && clean_ip.[i+1] = ':' then i
          else find_pos (i + 1)
        in
        find_pos 0 in

      if double_colon_pos = -1 then
        raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip))
      else
        let before_part =
          if double_colon_pos = 0 then ""
          else String.sub clean_ip 0 double_colon_pos in
        let after_part =
          let start = double_colon_pos + 2 in
          if start >= String.length clean_ip then ""
          else String.sub clean_ip start (String.length clean_ip - start) in

        let before_groups = if before_part = "" then [] else split_string before_part ':' in
        let after_groups = if after_part = "" then [] else split_string after_part ':' in
        let total_existing = List.length before_groups + List.length after_groups in
        let zeros_needed = 8 - total_existing in
        let zero_groups = List.init zeros_needed (fun _ -> "0") in

        String.concat ":" (before_groups @ zero_groups @ after_groups)
    else
      clean_ip in

  (* Parse the expanded IPv6 *)
  let hex_parts = split_string expanded_ip ':' in
  if List.length hex_parts = 8 then
    let hex = String.concat "" (List.map (fun part ->
      Printf.sprintf "%04s" (to_hex6 part) |>
      String.map (function ' ' -> '0' | c -> c)) hex_parts) in
    (hex, port)
  else
    raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip))

(* Main parsing function *)
let parse_ip ip =
  (* Check if it looks like IPv4 (contains dots but no colons except maybe one for port) *)
  if string_contains ip "." &&
     (not (string_contains ip ":") ||
      (let colon_count = List.length (split_string ip ':') - 1 in colon_count = 1)) then
    parse_ipv4 ip
  else if string_contains ip ":" then
    parse_ipv6 ip
  else
    raise (Invalid_address ("ERROR 103: Unknown address: " ^ ip))

(* Test cases *)
let tests = [|
  "192.168.0.1";
  "127.0.0.1";
  "256.0.0.1";
  "127.0.0.1:80";
  "::1";
  "[::1]:80";
  "[32e::12f]:80";
  "2605:2700:0:3::4713:93e3";
  "[2605:2700:0:3::4713:93e3]:80";
  "2001:db8:85a3:0:0:8a2e:370:7334"
|]

(* Main function *)
let () =
  printf "%-40s %-32s   %s\n" "Test Case" "Hex Address" "Port";
  Array.iter (fun ip ->
    try
      let (hex_addr, port) = parse_ip ip in
      printf "%-40s %-32s   %s\n" ip hex_addr port
    with Invalid_address msg ->
      printf "%-40s Invalid address:  %s\n" ip msg
  ) tests
