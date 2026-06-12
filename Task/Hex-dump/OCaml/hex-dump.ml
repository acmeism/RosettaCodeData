open Printf

let bytes_hex = 16
and bytes_bin = 6

let print_hex data =
  let print_8th_space i =
    if i mod 8 = 0 then (
      printf " ";
    );
  in
  Bytes.iteri (fun i c ->
      print_8th_space i;
      printf " %02x" (int_of_char c);
    ) data;
  for i = Bytes.length data to bytes_hex - 1 do
    print_8th_space i;
    printf "   ";
  done;
  ()

let print_binary data =
  printf " ";
  Bytes.iteri (fun i c ->
      printf " ";
      for shift = 7 downto 0 do
        let bit = (int_of_char c) land (1 lsl shift) <> 0 in
        printf (if bit then "1" else "0");
      done;
    ) data;
  for i = Bytes.length data to bytes_bin - 1 do
    printf "         ";
  done;
  ()

let print_chars data =
  Bytes.iter (fun c ->
      printf "%c" (match c with ' ' .. '~' -> c | _ -> '.');
    ) data;
  ()


type config = {
  offset : int64;
  max_length : int64;
  binary : bool;
}

let dump_file config file =
  let offset = min config.offset (In_channel.length file) in
  let config = { config with offset } in
  In_channel.seek file config.offset;

  let rec aux offset =
    printf "%08Lx" offset;

    let max_count = Int64.of_int (if config.binary then bytes_bin else bytes_hex) in
    let read_count = Int64.sub offset config.offset in
    let count = min max_count (Int64.sub config.max_length read_count) in
    let data = Bytes.create (Int64.to_int count) in (
      try
        Bytes.iteri (fun i _ ->
            Bytes.set data i (input_char file);
          ) data;
      with
      | End_of_file -> ()
    );
    let count = Int64.sub (In_channel.pos file) offset in
    let data = Bytes.sub data 0 (Int64.to_int count) in

    if count = 0L then (
      printf "\n";
    ) else (
      if config.binary then (
        print_binary data;
      ) else (
        print_hex data;
      );

      printf("  |");
      print_chars data;
      printf "|\n";

      aux (Int64.add offset count);
    );
  in
  aux config.offset;
  ()


exception Invalid_cli_args
exception Invalid_cli_arg of string * string

let check_arg_index i =
  if i >= Array.length Sys.argv then
    raise Invalid_cli_args

let get_int64_arg i name =
  match Int64.of_string_opt Sys.argv.(i) with
  | None -> raise @@ Invalid_cli_arg (name, Sys.argv.(i))
  | Some value ->
      if value < 0L then
        raise @@ Invalid_cli_arg (name, Sys.argv.(i))
      else
        value

let rec read_args config i =
  check_arg_index i;
  match Sys.argv.(i) with
  | "-b" ->
      read_args { config with binary = true } (i + 1)
  | "-s" ->
      check_arg_index (i + 1);
      let offset = get_int64_arg (i + 1) "skip" in
      read_args { config with offset } (i + 2)
  | "-n" ->
      check_arg_index (i + 1);
      let max_length = get_int64_arg (i + 1) "length" in
      read_args { config with max_length } (i + 2)
  | _ -> config, i

let () =
  try
    let config = {
        offset = 0L;
        max_length = Int64.max_int;
        binary = false;
      } in
    let config, i = read_args config 1 in

    if Array.length Sys.argv > i + 1 then (
      raise Invalid_cli_args;
    );

    In_channel.with_open_bin Sys.argv.(i) (dump_file config);

  with
  | Invalid_cli_args ->
      eprintf "Usage: %s [-b] [-s skip] [-n length] filename\n" Sys.argv.(0);
  | Invalid_cli_arg (name, value) ->
      eprintf "Invalid %s: '%s'.\n" name value;
