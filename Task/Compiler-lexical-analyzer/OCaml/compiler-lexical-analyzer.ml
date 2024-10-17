(*------------------------------------------------------------------*)
(* The Rosetta Code lexical analyzer, in OCaml. Based on the ATS.   *)

(* When you compare this code to the ATS code, please keep in mind
   that, although ATS has an ML-like syntax:

    * The type system is not the same at all.

    * Most ATS functions are not closures. Those that are will have
   special notations such as "<cloref1>" associated with them. *)

(*------------------------------------------------------------------*)
(* The following functions are compatible with ASCII. *)

let is_digit ichar =
  48 <= ichar && ichar <= 57

let is_lower ichar =
  97 <= ichar && ichar <= 122

let is_upper ichar =
  65 <= ichar && ichar <= 90

let is_alpha ichar =
  is_lower ichar || is_upper ichar

let is_alnum ichar =
  is_digit ichar || is_alpha ichar

let is_ident_start ichar =
  is_alpha ichar || ichar = 95

let is_ident_continuation ichar =
  is_alnum ichar || ichar = 95

let is_space ichar =
  ichar = 32 || (9 <= ichar && ichar <= 13)

(*------------------------------------------------------------------*)

let reverse_list_to_string lst =
  List.rev lst |> List.to_seq |> String.of_seq

(*------------------------------------------------------------------*)
(* Character input more like that of C. There are various advantages
   and disadvantages to this method, but key points in its favor are:
   (a) it is how character input is done in the original ATS code, (b)
   Unicode code points are 21-bit positive integers. *)

let eof = (-1)

let input_ichar channel =
  try
    int_of_char (input_char channel)
  with
  | End_of_file -> eof

(*------------------------------------------------------------------*)

(* The type of an input character. *)

module Ch =
  struct
    type t =
      {
        ichar : int;
        line_no : int;
        column_no : int
      }
  end

(*------------------------------------------------------------------*)
(* Inputting with unlimited pushback, and with counting of lines and
   columns. *)

module Inp =
  struct
    type t =
      {
        inpf : in_channel;
        pushback : Ch.t list;
        line_no : int;
        column_no : int
      }

    let of_in_channel inpf =
      { inpf = inpf;
        pushback = [];
        line_no = 1;
        column_no = 1
      }

    let get_ch inp =
      match inp.pushback with
      | ch :: tail ->
         (ch, {inp with pushback = tail})
      | [] ->
         let ichar = input_ichar inp.inpf in
         if ichar = int_of_char '\n' then
           ({ ichar = ichar;
              line_no = inp.line_no;
              column_no = inp.column_no },
            { inp with line_no = inp.line_no + 1;
                       column_no = 1 })
         else
           ({ ichar = ichar;
              line_no = inp.line_no;
              column_no = inp.column_no },
            { inp with column_no = inp.column_no + 1 })

    let push_back_ch ch inp =
      {inp with pushback = ch :: inp.pushback}
  end

(*------------------------------------------------------------------*)
(* Tokens, appearing in tuples with arguments, and with line and
   column numbers. The tokens are integers, so they can be used as
   array indices. *)

(* (token, argument, line_no, column_no) *)
type toktup_t = int * string * int * int

let token_ELSE         =  0
let token_IF           =  1
let token_PRINT        =  2
let token_PUTC         =  3
let token_WHILE        =  4
let token_MULTIPLY     =  5
let token_DIVIDE       =  6
let token_MOD          =  7
let token_ADD          =  8
let token_SUBTRACT     =  9
let token_NEGATE       = 10
let token_LESS         = 11
let token_LESSEQUAL    = 12
let token_GREATER      = 13
let token_GREATEREQUAL = 14
let token_EQUAL        = 15
let token_NOTEQUAL     = 16
let token_NOT          = 17
let token_ASSIGN       = 18
let token_AND          = 19
let token_OR           = 20
let token_LEFTPAREN    = 21
let token_RIGHTPAREN   = 22
let token_LEFTBRACE    = 23
let token_RIGHTBRACE   = 24
let token_SEMICOLON    = 25
let token_COMMA        = 26
let token_IDENTIFIER   = 27
let token_INTEGER      = 28
let token_STRING       = 29
let token_END_OF_INPUT = 30
;;

(* A *very* simple perfect hash for the reserved words. (Yes, this is
   overkill, except for demonstration of the principle.) *)

let reserved_words =
  [| "if"; "print"; "else"; ""; "putc"; ""; ""; "while"; "" |]
let reserved_word_tokens =
  [| token_IF; token_PRINT; token_ELSE; token_IDENTIFIER;
     token_PUTC; token_IDENTIFIER; token_IDENTIFIER; token_WHILE;
     token_IDENTIFIER |]

let reserved_word_lookup s line_no column_no =
  if String.length s < 2 then
    (token_IDENTIFIER, s, line_no, column_no)
  else
    let hashval = (int_of_char s.[0] + int_of_char s.[1]) mod 9 in
    let token = reserved_word_tokens.(hashval) in
    if token = token_IDENTIFIER || s <> reserved_words.(hashval) then
      (token_IDENTIFIER, s, line_no, column_no)
    else
      (token, s, line_no, column_no)

(* Token to string lookup. *)

let token_names =
  [| "Keyword_else";
     "Keyword_if";
     "Keyword_print";
     "Keyword_putc";
     "Keyword_while";
     "Op_multiply";
     "Op_divide";
     "Op_mod";
     "Op_add";
     "Op_subtract";
     "Op_negate";
     "Op_less";
     "Op_lessequal";
     "Op_greater";
     "Op_greaterequal";
     "Op_equal";
     "Op_notequal";
     "Op_not";
     "Op_assign";
     "Op_and";
     "Op_or";
     "LeftParen";
     "RightParen";
     "LeftBrace";
     "RightBrace";
     "Semicolon";
     "Comma";
     "Identifier";
     "Integer";
     "String";
     "End_of_input" |]

let token_name token =
  token_names.(token)

(*------------------------------------------------------------------*)

exception Unterminated_comment of int * int
exception Unterminated_character_literal of int * int
exception Multicharacter_literal of int * int
exception End_of_input_in_string_literal of int * int
exception End_of_line_in_string_literal of int * int
exception Unsupported_escape of int * int * int
exception Invalid_integer_literal of int * int * string
exception Unexpected_character of int * int * char

(*------------------------------------------------------------------*)
(* Skipping past spaces and comments. (A comment in the target
   language is, if you think about it, a kind of space.) *)

let scan_comment inp line_no column_no =
  let rec loop inp =
    let (ch, inp) = Inp.get_ch inp in
    if ch.ichar = eof then
      raise (Unterminated_comment (line_no, column_no))
    else if ch.ichar = int_of_char '*' then
      let (ch1, inp) = Inp.get_ch inp in
      if ch1.ichar = eof then
        raise (Unterminated_comment (line_no, column_no))
      else if ch1.ichar = int_of_char '/' then
        inp
      else
        loop inp
    else
      loop inp
  in
  loop inp

let skip_spaces_and_comments inp =
  let rec loop inp =
    let (ch, inp) = Inp.get_ch inp in
    if is_space ch.ichar then
      loop inp
    else if ch.ichar = int_of_char '/' then
      let (ch1, inp) = Inp.get_ch inp in
      if ch1.ichar = int_of_char '*' then
        scan_comment inp ch.line_no ch.column_no |> loop
      else
        let inp = Inp.push_back_ch ch1 inp in
        let inp = Inp.push_back_ch ch inp in
        inp
    else
      Inp.push_back_ch ch inp
  in
  loop inp

(*------------------------------------------------------------------*)
(* Integer literals, identifiers, and reserved words. *)

(* In ATS the predicate for simple scan was supplied by template
   expansion, which (typically) produces faster code than passing a
   function or closure (although passing either of those could have
   been done). Here I pass the predicate as a function/closure. It is
   worth contrasting the methods. *)
let rec simple_scan pred lst inp =
  let (ch, inp) = Inp.get_ch inp in
  if pred ch.ichar then
    simple_scan pred (char_of_int ch.ichar :: lst) inp
  else
    (lst, Inp.push_back_ch ch inp)

(* Demonstration of one way to make a new closure in OCaml. (In ATS,
   one might see things that look similar but are actually template
   operations.) *)
let simple_scan_iic = simple_scan is_ident_continuation

let scan_integer_literal inp =
  let (ch, inp) = Inp.get_ch inp in
  let _ = assert (is_digit ch.ichar) in
  let (lst, inp) = simple_scan_iic [char_of_int ch.ichar] inp in
  let s = reverse_list_to_string lst in
  if List.for_all (fun c -> is_digit (int_of_char c)) lst then
    ((token_INTEGER, s, ch.line_no, ch.column_no), inp)
  else
    raise (Invalid_integer_literal (ch.line_no, ch.column_no, s))

let scan_identifier_or_reserved_word inp =
  let (ch, inp) = Inp.get_ch inp in
  let _ = assert (is_ident_start ch.ichar) in
  let (lst, inp) = simple_scan_iic [char_of_int ch.ichar] inp in
  let s = reverse_list_to_string lst in
  let toktup = reserved_word_lookup s ch.line_no ch.column_no in
  (toktup, inp)

(*------------------------------------------------------------------*)
(* String literals. *)

let scan_string_literal inp =
  let (ch, inp) = Inp.get_ch inp in
  let _ = assert (ch.ichar = int_of_char '"') in

  let rec scan lst inp =
    let (ch1, inp) = Inp.get_ch inp in
    if ch1.ichar = eof then
      raise (End_of_input_in_string_literal
               (ch.line_no, ch.column_no))
    else if ch1.ichar = int_of_char '\n' then
      raise (End_of_line_in_string_literal
               (ch.line_no, ch.column_no))
    else if ch1.ichar = int_of_char '"' then
      (lst, inp)
    else if ch1.ichar <> int_of_char '\\' then
      scan (char_of_int ch1.ichar :: lst) inp
    else
      let (ch2, inp) = Inp.get_ch inp in
      if ch2.ichar = int_of_char 'n' then
        scan ('n' :: '\\' :: lst) inp
      else if ch2.ichar = int_of_char '\\' then
        scan ('\\' :: '\\' :: lst) inp
      else
        raise (Unsupported_escape (ch1.line_no, ch1.column_no,
                                   ch2.ichar))
  in
  let lst = '"' :: [] in
  let (lst, inp) = scan lst inp in
  let lst = '"' :: lst in
  let s = reverse_list_to_string lst in
  ((token_STRING, s, ch.line_no, ch.column_no), inp)

(*------------------------------------------------------------------*)
(* Character literals. *)

let scan_character_literal_without_checking_end inp =
  let (ch, inp) = Inp.get_ch inp in
  let _ = assert (ch.ichar = int_of_char '\'') in
  let (ch1, inp) = Inp.get_ch inp in
  if ch1.ichar = eof then
    raise (Unterminated_character_literal
             (ch.line_no, ch.column_no))
  else if ch1.ichar = int_of_char '\\' then
    let (ch2, inp) = Inp.get_ch inp in
    if ch2.ichar = eof then
      raise (Unterminated_character_literal
               (ch.line_no, ch.column_no))
    else if ch2.ichar = int_of_char 'n' then
      let s = (int_of_char '\n' |> string_of_int) in
      ((token_INTEGER, s, ch.line_no, ch.column_no), inp)
    else if ch2.ichar = int_of_char '\\' then
      let s = (int_of_char '\\' |> string_of_int) in
      ((token_INTEGER, s, ch.line_no, ch.column_no), inp)
    else
      raise (Unsupported_escape
               (ch1.line_no, ch1.column_no, ch2.ichar))
  else
    let s = string_of_int ch1.ichar in
    ((token_INTEGER, s, ch.line_no, ch.column_no), inp)

let scan_character_literal inp =
  let (toktup, inp) =
    scan_character_literal_without_checking_end inp in
  let (_, _, line_no, column_no) = toktup in

  let check_end inp =
    let (ch, inp) = Inp.get_ch inp in
    if ch.ichar = int_of_char '\'' then
      inp
    else
      let rec loop_to_end (ch1 : Ch.t) inp =
        if ch1.ichar = eof then
          raise (Unterminated_character_literal (line_no, column_no))
        else if ch1.ichar = int_of_char '\'' then
          raise (Multicharacter_literal (line_no, column_no))
        else
          let (ch1, inp) = Inp.get_ch inp in
          loop_to_end ch1 inp
      in
      loop_to_end ch inp
  in
  let inp = check_end inp in
  (toktup, inp)

(*------------------------------------------------------------------*)

let get_next_token inp =
  let inp = skip_spaces_and_comments inp in
  let (ch, inp) = Inp.get_ch inp in
  let ln = ch.line_no in
  let cn = ch.column_no in
  if ch.ichar = eof then
    ((token_END_OF_INPUT, "", ln, cn), inp)
  else
    match char_of_int ch.ichar with
    | ',' -> ((token_COMMA, ",", ln, cn), inp)
    | ';' -> ((token_SEMICOLON, ";", ln, cn), inp)
    | '(' -> ((token_LEFTPAREN, "(", ln, cn), inp)
    | ')' -> ((token_RIGHTPAREN, ")", ln, cn), inp)
    | '{' -> ((token_LEFTBRACE, "{", ln, cn), inp)
    | '}' -> ((token_RIGHTBRACE, "}", ln, cn), inp)
    | '*' -> ((token_MULTIPLY, "*", ln, cn), inp)
    | '/' -> ((token_DIVIDE, "/", ln, cn), inp)
    | '%' -> ((token_MOD, "%", ln, cn), inp)
    | '+' -> ((token_ADD, "+", ln, cn), inp)
    | '-' -> ((token_SUBTRACT, "-", ln, cn), inp)
    | '<' ->
       let (ch1, inp) = Inp.get_ch inp in
       if ch1.ichar = int_of_char '=' then
         ((token_LESSEQUAL, "<=", ln, cn), inp)
       else
         let inp = Inp.push_back_ch ch1 inp in
         ((token_LESS, "<", ln, cn), inp)
    | '>' ->
       let (ch1, inp) = Inp.get_ch inp in
       if ch1.ichar = int_of_char '=' then
         ((token_GREATEREQUAL, ">=", ln, cn), inp)
       else
         let inp = Inp.push_back_ch ch1 inp in
         ((token_GREATER, ">", ln, cn), inp)
    | '=' ->
       let (ch1, inp) = Inp.get_ch inp in
       if ch1.ichar = int_of_char '=' then
         ((token_EQUAL, "==", ln, cn), inp)
       else
         let inp = Inp.push_back_ch ch1 inp in
         ((token_ASSIGN, "=", ln, cn), inp)
    | '!' ->
       let (ch1, inp) = Inp.get_ch inp in
       if ch1.ichar = int_of_char '=' then
         ((token_NOTEQUAL, "!=", ln, cn), inp)
       else
         let inp = Inp.push_back_ch ch1 inp in
         ((token_NOT, "!", ln, cn), inp)
    | '&' ->
       let (ch1, inp) = Inp.get_ch inp in
       if ch1.ichar = int_of_char '&' then
         ((token_AND, "&&", ln, cn), inp)
       else
         raise (Unexpected_character (ch.line_no, ch.column_no,
                                      char_of_int ch.ichar))
    | '|' ->
       let (ch1, inp) = Inp.get_ch inp in
       if ch1.ichar = int_of_char '|' then
         ((token_OR, "||", ln, cn), inp)
       else
         raise (Unexpected_character (ch.line_no, ch.column_no,
                                      char_of_int ch.ichar))
    | '"' ->
       let inp = Inp.push_back_ch ch inp in
       scan_string_literal inp
    | '\'' ->
       let inp = Inp.push_back_ch ch inp in
       scan_character_literal inp
    | _ when is_digit ch.ichar ->
       let inp = Inp.push_back_ch ch inp in
       scan_integer_literal inp
    | _ when is_ident_start ch.ichar ->
       let inp = Inp.push_back_ch ch inp in
       scan_identifier_or_reserved_word inp
    | _ -> raise (Unexpected_character (ch.line_no, ch.column_no,
                                        char_of_int ch.ichar))

let print_token outf toktup =
  let (token, arg, line_no, column_no) = toktup in
  let name = token_name token in
  let (padding, str) =
    match 0 with
    | _ when token = token_IDENTIFIER -> ("     ", arg)
    | _ when token = token_INTEGER -> ("        ", arg)
    | _ when token = token_STRING -> ("         ", arg)
    | _ -> ("", "")
  in
  Printf.fprintf outf "%5d %5d  %s%s%s\n"
    line_no column_no name padding str

let scan_text outf inp =
  let rec loop inp =
    let (toktup, inp) = get_next_token inp in
    begin
      print_token outf toktup;
      let (token, _, _, _) = toktup in
      if token <> token_END_OF_INPUT then
        loop inp
    end
  in
  loop inp

(*------------------------------------------------------------------*)

let main () =
  let inpf_filename =
    if 2 <= Array.length Sys.argv then
      Sys.argv.(1)
    else
      "-"
  in
  let outf_filename =
    if 3 <= Array.length Sys.argv then
      Sys.argv.(2)
    else
      "-"
  in
  let inpf =
    if inpf_filename = "-" then
      stdin
    else
      open_in inpf_filename
  in
  let outf =
    if outf_filename = "-" then
      stdout
    else
      open_out outf_filename
  in
  let inp = Inp.of_in_channel inpf in
  scan_text outf inp
;;

main ()

(*------------------------------------------------------------------*)
