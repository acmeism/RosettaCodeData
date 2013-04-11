(** This module is a very simple parsing library for S-expressions. *)
(* Copyright (C) 2009  Florent Monnier, released under MIT license. *)
(* modified to match the task description *)

type sexpr = Atom of string | Expr of sexpr list

type state =
  | Parse_root of sexpr list
  | Parse_content of sexpr list
  | Parse_word of Buffer.t * sexpr list
  | Parse_string of bool * Buffer.t * sexpr list

let parse pop_char =
  let rec aux st =
    match pop_char() with
    | None ->
        begin match st with
        | Parse_root sl -> (List.rev sl)
        | Parse_content _
        | Parse_word _
        | Parse_string _ ->
            failwith "Parsing error: content not closed by parenthesis"
        end
    | Some c ->
        match c with
        | '(' ->
            begin match st with
            | Parse_root sl ->
                let this = aux(Parse_content []) in
                aux(Parse_root((Expr this)::sl))
            | Parse_content sl ->
                let this = aux(Parse_content []) in
                aux(Parse_content((Expr this)::sl))
            | Parse_word(w, sl) ->
                let this = aux(Parse_content []) in
                aux(Parse_content((Expr this)::Atom(Buffer.contents w)::sl))
            | Parse_string(_, s, sl) ->
                Buffer.add_char s c;
                aux(Parse_string(false, s, sl))
            end
        | ')' ->
            begin match st with
            | Parse_root sl ->
                failwith "Parsing error: closing parenthesis without openning"
            | Parse_content sl -> (List.rev sl)
            | Parse_word(w, sl) -> List.rev(Atom(Buffer.contents w)::sl)
            | Parse_string(_, s, sl) ->
                Buffer.add_char s c;
                aux(Parse_string(false, s, sl))
            end
        | ' ' | '\n' | '\r' | '\t' ->
            begin match st with
            | Parse_root sl -> aux(Parse_root sl)
            | Parse_content sl -> aux(Parse_content sl)
            | Parse_word(w, sl) -> aux(Parse_content(Atom(Buffer.contents w)::sl))
            | Parse_string(_, s, sl) ->
                Buffer.add_char s c;
                aux(Parse_string(false, s, sl))
            end
        | '"' ->
            (* '"' *)
            begin match st with
            | Parse_root _ -> failwith "Parse error: double quote at root level"
            | Parse_content sl ->
                let s = Buffer.create 74 in
                aux(Parse_string(false, s, sl))
            | Parse_word(w, sl) ->
                let s = Buffer.create 74 in
                aux(Parse_string(false, s, Atom(Buffer.contents w)::sl))
            | Parse_string(true, s, sl) ->
                Buffer.add_char s c;
                aux(Parse_string(false, s, sl))
            | Parse_string(false, s, sl) ->
                aux(Parse_content(Atom(Buffer.contents s)::sl))
            end
        | '\\' ->
            begin match st with
            | Parse_string(true, s, sl) ->
                Buffer.add_char s c;
                aux(Parse_string(false, s, sl))
            | Parse_string(false, s, sl) ->
                aux(Parse_string(true, s, sl))
            | _ ->
                failwith "Parsing error: escape character in wrong place"
            end
        | _ ->
            begin match st with
            | Parse_root _ ->
                failwith(Printf.sprintf "Parsing error: char '%c' at root level" c)
            | Parse_content sl ->
                let w = Buffer.create 16 in
                Buffer.add_char w c;
                aux(Parse_word(w, sl))
            | Parse_word(w, sl) ->
                Buffer.add_char w c;
                aux(Parse_word(w, sl))
            | Parse_string(_, s, sl) ->
                Buffer.add_char s c;
                aux(Parse_string(false, s, sl))
            end
  in
  aux (Parse_root [])


let string_pop_char str =
  let len = String.length str in
  let i = ref(-1) in
  (function () -> incr i; if !i >= len then None else Some(str.[!i]))


let parse_string str =
  parse (string_pop_char str)


let ic_pop_char ic =
  (function () ->
     try Some(input_char ic)
     with End_of_file -> (None))


let parse_ic ic =
  parse (ic_pop_char ic)


let parse_file filename =
  let ic = open_in filename in
  let res = parse_ic ic in
  close_in ic;
  (res)


let quote s =
  "\"" ^ s ^ "\""

let needs_quote s =
  List.exists (String.contains s) [' '; '\n'; '\r'; '\t'; '('; ')']

let protect s =
  let s = String.escaped s in
  if needs_quote s then quote s else s


let string_of_sexpr s =
  let rec aux acc = function
  | (Atom tag)::tl -> aux ((protect tag)::acc) tl
  | (Expr e)::tl ->
      let s =
        "(" ^
        (String.concat " " (aux [] e))
        ^ ")"
      in
      aux (s::acc) tl
  | [] -> (List.rev acc)
  in
  String.concat " " (aux [] s)


let print_sexpr s =
  print_endline (string_of_sexpr s)


let string_of_sexpr_indent s =
  let rec aux i acc = function
  | (Atom tag)::tl -> aux i ((protect tag)::acc) tl
  | (Expr e)::tl ->
      let s =
        "\n" ^ (String.make i ' ') ^ "(" ^
        (String.concat " " (aux (succ i) [] e))
        ^ ")"
      in
      aux i (s::acc) tl
  | [] -> (List.rev acc)
  in
  String.concat "\n" (aux 0 [] s)


let print_sexpr_indent s =
  print_endline (string_of_sexpr_indent s)
