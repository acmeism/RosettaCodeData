(*------------------------------------------------------------------*)
(* The Rosetta Code lexical analyzer, in Standard ML. Based on the ATS
   and the OCaml. The intended compiler is Mlton or Poly/ML; there is
   a tiny difference near the end of the file, depending on which
   compiler is used. *)

(*------------------------------------------------------------------*)
(* The following functions are compatible with ASCII. *)

fun
is_digit ichar =
48 <= ichar andalso ichar <= 57

fun
is_lower ichar =
97 <= ichar andalso ichar <= 122

fun
is_upper ichar =
65 <= ichar andalso ichar <= 90

fun
is_alpha ichar =
is_lower ichar orelse is_upper ichar

fun
is_alnum ichar =
is_digit ichar orelse is_alpha ichar

fun
is_ident_start ichar =
is_alpha ichar orelse ichar = 95

fun
is_ident_continuation ichar =
is_alnum ichar orelse ichar = 95

fun
is_space ichar =
ichar = 32 orelse (9 <= ichar andalso ichar <= 13)

(*------------------------------------------------------------------*)
(* Character input more like that of C. There are various advantages
   and disadvantages to this method, but key points in its favor are:
   (a) it is how character input is done in the original ATS code, (b)
   Unicode code points are 21-bit positive integers. *)

val eof = ~1

fun
input_ichar inpf =
case TextIO.input1 inpf of
    NONE => eof
  | SOME c => Char.ord c

(*------------------------------------------------------------------*)

(* The type of an input character. *)

structure Ch =
struct

type t = {
  ichar : int,
  line_no : int,
  column_no : int
}

end

(*------------------------------------------------------------------*)
(* Inputting with unlimited pushback, and with counting of lines and
   columns. *)

structure Inp =
struct

type t = {
  inpf : TextIO.instream,
  pushback : Ch.t list,
  line_no : int,
  column_no : int
}

fun
of_instream inpf =
{
  inpf = inpf,
  pushback = [],
  line_no = 1,
  column_no = 1
} : t

fun
get_ch ({ inpf = inpf,
          pushback = pushback,
          line_no = line_no,
          column_no = column_no } : t) =
case pushback of
    ch :: tail =>
    let
      val inp = { inpf = inpf,
                  pushback = tail,
                  line_no = line_no,
                  column_no = column_no }
    in
      (ch, inp)
    end
  | [] =>
    let
      val ichar = input_ichar inpf
      val ch = { ichar = ichar,
                 line_no = line_no,
                 column_no = column_no }
    in
      if ichar = Char.ord #"\n" then
        let
          val inp = { inpf = inpf,
                      pushback = [],
                      line_no = line_no + 1,
                      column_no = 1 }
        in
          (ch, inp)
        end
      else
        let
          val inp = { inpf = inpf,
                      pushback = [],
                      line_no = line_no,
                      column_no = column_no + 1 }
        in
          (ch, inp)
        end
    end

fun
push_back_ch (ch, inp : t) =
{
  inpf = #inpf inp,
  pushback = ch :: #pushback inp,
  line_no = #line_no inp,
  column_no = #column_no inp
}

end

(*------------------------------------------------------------------*)
(* Tokens, appearing in tuples with arguments, and with line and
   column numbers. The tokens are integers, so they can be used as
   array indices. *)

val token_ELSE         =  0
val token_IF           =  1
val token_PRINT        =  2
val token_PUTC         =  3
val token_WHILE        =  4
val token_MULTIPLY     =  5
val token_DIVIDE       =  6
val token_MOD          =  7
val token_ADD          =  8
val token_SUBTRACT     =  9
val token_NEGATE       = 10
val token_LESS         = 11
val token_LESSEQUAL    = 12
val token_GREATER      = 13
val token_GREATEREQUAL = 14
val token_EQUAL        = 15
val token_NOTEQUAL     = 16
val token_NOT          = 17
val token_ASSIGN       = 18
val token_AND          = 19
val token_OR           = 20
val token_LEFTPAREN    = 21
val token_RIGHTPAREN   = 22
val token_LEFTBRACE    = 23
val token_RIGHTBRACE   = 24
val token_SEMICOLON    = 25
val token_COMMA        = 26
val token_IDENTIFIER   = 27
val token_INTEGER      = 28
val token_STRING       = 29
val token_END_OF_INPUT = 30

(* A *very* simple perfect hash for the reserved words. (Yes, this is
   overkill, except for demonstration of the principle.) *)

val reserved_words =
    Vector.fromList ["if", "print", "else",
                     "", "putc", "",
                     "", "while", ""]
val reserved_word_tokens =
    Vector.fromList [token_IF, token_PRINT, token_ELSE,
                     token_IDENTIFIER, token_PUTC, token_IDENTIFIER,
                     token_IDENTIFIER, token_WHILE, token_IDENTIFIER]

fun
reserved_word_lookup (s, line_no, column_no) =
if (String.size s) < 2 then
  (token_IDENTIFIER, s, line_no, column_no)
else
  let
    val hashval =
        (Char.ord (String.sub (s, 0)) +
         Char.ord (String.sub (s, 1)))
        mod 9
    val token = Vector.sub (reserved_word_tokens, hashval)
  in
    if token = token_IDENTIFIER orelse
       s <> Vector.sub (reserved_words, hashval) then
      (token_IDENTIFIER, s, line_no, column_no)
    else
      (token, s, line_no, column_no)
  end

(* Token to string lookup. *)

val token_names =
    Vector.fromList
      ["Keyword_else",
       "Keyword_if",
       "Keyword_print",
       "Keyword_putc",
       "Keyword_while",
       "Op_multiply",
       "Op_divide",
       "Op_mod",
       "Op_add",
       "Op_subtract",
       "Op_negate",
       "Op_less",
       "Op_lessequal",
       "Op_greater",
       "Op_greaterequal",
       "Op_equal",
       "Op_notequal",
       "Op_not",
       "Op_assign",
       "Op_and",
       "Op_or",
       "LeftParen",
       "RightParen",
       "LeftBrace",
       "RightBrace",
       "Semicolon",
       "Comma",
       "Identifier",
       "Integer",
       "String",
       "End_of_input"]

fun
token_name token =
  Vector.sub (token_names, token)

(*------------------------------------------------------------------*)

exception Unterminated_comment of int * int
exception Unterminated_character_literal of int * int
exception Multicharacter_literal of int * int
exception End_of_input_in_string_literal of int * int
exception End_of_line_in_string_literal of int * int
exception Unsupported_escape of int * int * char
exception Invalid_integer_literal of int * int * string
exception Unexpected_character of int * int * char

(*------------------------------------------------------------------*)
(* Skipping past spaces and comments. (In the Rosetta Code tiny
   language, a comment, if you think about it, is a kind of space.) *)

fun
scan_comment (inp, line_no, column_no) =
let
  fun
  loop inp =
  let
    val (ch, inp) = Inp.get_ch inp
  in
    if #ichar ch = eof then
      raise Unterminated_comment (line_no, column_no)
    else if #ichar ch = Char.ord #"*" then
      let
        val (ch1, inp) = Inp.get_ch inp
      in
        if #ichar ch1 = eof then
          raise Unterminated_comment (line_no, column_no)
        else if #ichar ch1 = Char.ord #"/" then
          inp
        else
          loop inp
      end
    else
      loop inp
  end
in
  loop inp
end

fun
skip_spaces_and_comments inp =
let
  fun
  loop inp =
  let
    val (ch, inp) = Inp.get_ch inp
  in
    if is_space (#ichar ch) then
      loop inp
    else if #ichar ch = Char.ord #"/" then
      let
        val (ch1, inp) = Inp.get_ch inp
      in
        if #ichar ch1 = Char.ord #"*" then
          loop (scan_comment (inp, #line_no ch, #column_no ch))
        else
          let
            val inp = Inp.push_back_ch (ch1, inp)
            val inp = Inp.push_back_ch (ch, inp)
          in
            inp
          end
      end
    else
      Inp.push_back_ch (ch, inp)
  end
in
  loop inp
end

(*------------------------------------------------------------------*)
(* Integer literals, identifiers, and reserved words. *)

fun
scan_word (lst, inp) =
let
  val (ch, inp) = Inp.get_ch inp
in
  if is_ident_continuation (#ichar ch) then
    scan_word (Char.chr (#ichar ch) :: lst, inp)
  else
    (lst, Inp.push_back_ch (ch, inp))
end

fun
scan_integer_literal inp =
let
  val (ch, inp) = Inp.get_ch inp
  val (lst, inp) = scan_word ([Char.chr (#ichar ch)], inp)
  val s = String.implode (List.rev lst)
in
  if List.all (fn c => is_digit (Char.ord c)) lst then
    ((token_INTEGER, s, #line_no ch, #column_no ch), inp)
  else
    raise Invalid_integer_literal (#line_no ch, #column_no ch, s)
end

fun
scan_identifier_or_reserved_word inp =
let
  val (ch, inp) = Inp.get_ch inp
  val (lst, inp) = scan_word ([Char.chr (#ichar ch)], inp)
  val s = String.implode (List.rev lst)
  val toktup = reserved_word_lookup (s, #line_no ch, #column_no ch)
in
  (toktup, inp)
end

(*------------------------------------------------------------------*)
(* String literals. *)

fun
scan_string_literal inp =
let
  val (ch, inp) = Inp.get_ch inp

  fun
  scan (lst, inp) =
  let
    val (ch1, inp) = Inp.get_ch inp
  in
    if #ichar ch1 = eof then
      raise End_of_input_in_string_literal
            (#line_no ch, #column_no ch)
    else if #ichar ch1 = Char.ord #"\n" then
      raise End_of_line_in_string_literal
            (#line_no ch, #column_no ch)
    else if #ichar ch1 = Char.ord #"\"" then
      (lst, inp)
    else if #ichar ch1 <> Char.ord #"\\" then
      scan (Char.chr (#ichar ch1) :: lst, inp)
    else
      let
        val (ch2, inp) = Inp.get_ch inp
      in
        if #ichar ch2 = Char.ord #"n" then
          scan (#"n" :: #"\\" :: lst, inp)
        else if #ichar ch2 = Char.ord #"\\" then
          scan (#"\\" :: #"\\" :: lst, inp)
        else if #ichar ch2 = eof then
          raise End_of_input_in_string_literal
                (#line_no ch, #column_no ch)
        else if #ichar ch2 = Char.ord #"\n" then
          raise End_of_line_in_string_literal
                (#line_no ch, #column_no ch)
        else
          raise Unsupported_escape (#line_no ch1, #column_no ch1,
                                    Char.chr (#ichar ch2))
      end
  end

  val lst = #"\"" :: []
  val (lst, inp) = scan (lst, inp)
  val lst = #"\"" :: lst
  val s = String.implode (List.rev lst)
in
  ((token_STRING, s, #line_no ch, #column_no ch), inp)
end

(*------------------------------------------------------------------*)
(* Character literals. *)

fun
scan_character_literal_without_checking_end inp =
let
  val (ch, inp) = Inp.get_ch inp
  val (ch1, inp) = Inp.get_ch inp
in
  if #ichar ch1 = eof then
    raise Unterminated_character_literal
          (#line_no ch, #column_no ch)
  else if #ichar ch1 = Char.ord #"\\" then
    let
      val (ch2, inp) = Inp.get_ch inp
    in
      if #ichar ch2 = eof then
        raise Unterminated_character_literal
              (#line_no ch, #column_no ch)
      else if #ichar ch2 = Char.ord #"n" then
        let
          val s = Int.toString (Char.ord #"\n")
        in
          ((token_INTEGER, s, #line_no ch, #column_no ch), inp)
        end
      else if #ichar ch2 = Char.ord #"\\" then
        let
          val s = Int.toString (Char.ord #"\\")
        in
          ((token_INTEGER, s, #line_no ch, #column_no ch), inp)
        end
      else
        raise Unsupported_escape (#line_no ch1, #column_no ch1,
                                  Char.chr (#ichar ch2))
    end
  else
    let
      val s = Int.toString (#ichar ch1)
    in
      ((token_INTEGER, s, #line_no ch, #column_no ch), inp)
    end
end

fun
scan_character_literal inp =
let
  val (toktup, inp) =
      scan_character_literal_without_checking_end inp
  val (_, _, line_no, column_no) = toktup

  fun
  check_end inp =
  let
    val (ch, inp) = Inp.get_ch inp
  in
    if #ichar ch = Char.ord #"'" then
      inp
    else
      let
        fun
        loop_to_end (ch1 : Ch.t, inp) =
        if #ichar ch1 = eof then
          raise Unterminated_character_literal (line_no, column_no)
        else if #ichar ch1 = Char.ord #"'" then
          raise Multicharacter_literal (line_no, column_no)
        else
          let
            val (ch1, inp) = Inp.get_ch inp
          in
            loop_to_end (ch1, inp)
          end
      in
        loop_to_end (ch, inp)
      end
  end

  val inp = check_end inp
in
  (toktup, inp)
end

(*------------------------------------------------------------------*)

fun
get_next_token inp =
let
  val inp = skip_spaces_and_comments inp
  val (ch, inp) = Inp.get_ch inp
  val ln = #line_no ch
  val cn = #column_no ch
in
  if #ichar ch = eof then
    ((token_END_OF_INPUT, "", ln, cn), inp)
  else
    case Char.chr (#ichar ch) of
        #"," => ((token_COMMA, ",", ln, cn), inp)
      | #";" => ((token_SEMICOLON, ";", ln, cn), inp)
      | #"(" => ((token_LEFTPAREN, "(", ln, cn), inp)
      | #")" => ((token_RIGHTPAREN, ")", ln, cn), inp)
      | #"{" => ((token_LEFTBRACE, "{", ln, cn), inp)
      | #"}" => ((token_RIGHTBRACE, "}", ln, cn), inp)
      | #"*" => ((token_MULTIPLY, "*", ln, cn), inp)
      | #"/" => ((token_DIVIDE, "/", ln, cn), inp)
      | #"%" => ((token_MOD, "%", ln, cn), inp)
      | #"+" => ((token_ADD, "+", ln, cn), inp)
      | #"-" => ((token_SUBTRACT, "-", ln, cn), inp)
      | #"<" =>
        let
          val (ch1, inp) = Inp.get_ch inp
        in
          if #ichar ch1 = Char.ord #"=" then
            ((token_LESSEQUAL, "<=", ln, cn), inp)
          else
            let
              val inp = Inp.push_back_ch (ch1, inp)
            in
              ((token_LESS, "<", ln, cn), inp)
            end
        end
      | #">" =>
        let
          val (ch1, inp) = Inp.get_ch inp
        in
          if #ichar ch1 = Char.ord #"=" then
            ((token_GREATEREQUAL, ">=", ln, cn), inp)
          else
            let
              val inp = Inp.push_back_ch (ch1, inp)
            in
              ((token_GREATER, ">", ln, cn), inp)
            end
        end
      | #"=" =>
        let
          val (ch1, inp) = Inp.get_ch inp
        in
          if #ichar ch1 = Char.ord #"=" then
            ((token_EQUAL, "==", ln, cn), inp)
          else
            let
              val inp = Inp.push_back_ch (ch1, inp)
            in
              ((token_ASSIGN, "=", ln, cn), inp)
            end
        end
      | #"!" =>
        let
          val (ch1, inp) = Inp.get_ch inp
        in
          if #ichar ch1 = Char.ord #"=" then
            ((token_NOTEQUAL, "!=", ln, cn), inp)
          else
            let
              val inp = Inp.push_back_ch (ch1, inp)
            in
              ((token_NOT, "!", ln, cn), inp)
            end
        end
      | #"&" =>
        let
          val (ch1, inp) = Inp.get_ch inp
        in
          if #ichar ch1 = Char.ord #"&" then
            ((token_AND, "&&", ln, cn), inp)
          else
            raise Unexpected_character (#line_no ch, #column_no ch,
                                        Char.chr (#ichar ch))
        end
      | #"|" =>
        let
          val (ch1, inp) = Inp.get_ch inp
        in
          if #ichar ch1 = Char.ord #"|" then
            ((token_OR, "||", ln, cn), inp)
          else
            raise Unexpected_character (#line_no ch, #column_no ch,
                                        Char.chr (#ichar ch))
        end
      | #"\"" =>
        let
          val inp = Inp.push_back_ch (ch, inp)
        in
          scan_string_literal inp
        end
      | #"'" =>
        let
          val inp = Inp.push_back_ch (ch, inp)
        in
          scan_character_literal inp
        end
      | _ =>
        if is_digit (#ichar ch) then
          let
            val inp = Inp.push_back_ch (ch, inp)
          in
            scan_integer_literal inp
          end
        else if is_ident_start (#ichar ch) then
          let
            val inp = Inp.push_back_ch (ch, inp)
          in
            scan_identifier_or_reserved_word inp
          end
        else
          raise Unexpected_character (#line_no ch, #column_no ch,
                                      Char.chr (#ichar ch))
end

fun
output_integer_rightjust (outf, num) =
(if num < 10 then
   TextIO.output (outf, "    ")
 else if num < 100 then
   TextIO.output (outf, "   ")
 else if num < 1000 then
   TextIO.output (outf, "  ")
 else if num < 10000 then
   TextIO.output (outf, " ")
 else
   ();
 TextIO.output (outf, Int.toString num))

fun
print_token (outf, toktup) =
let
  val (token, arg, line_no, column_no) = toktup
  val name = token_name token
  val (padding, str) =
      if token = token_IDENTIFIER then
        ("     ", arg)
      else if token = token_INTEGER then
        ("        ", arg)
      else if token = token_STRING then
        ("         ", arg)
      else("", "")
in
  output_integer_rightjust (outf, line_no);
  TextIO.output (outf, " ");
  output_integer_rightjust (outf, column_no);
  TextIO.output (outf, "  ");
  TextIO.output (outf, name);
  TextIO.output (outf, padding);
  TextIO.output (outf, str);
  TextIO.output (outf, "\n")
end

fun
scan_text (outf, inp) =
let
  fun
  loop inp =
  let
    val (toktup, inp) = get_next_token inp
  in
    (print_token (outf, toktup);
     let
       val (token, _, _, _) = toktup
     in
       if token <> token_END_OF_INPUT then
         loop inp
       else
         ()
     end)
  end
in
  loop inp
end

(*------------------------------------------------------------------*)

fun
main () =
let
  val args = CommandLine.arguments ()
  val (inpf_filename, outf_filename) =
      case args of
          [] => ("-", "-")
        | name :: [] => (name, "-")
        | name1 :: name2 :: _ => (name1, name2)
  val inpf =
      if inpf_filename = "-" then
        TextIO.stdIn
      else
        TextIO.openIn inpf_filename
        handle
        (IO.Io _) =>
        (TextIO.output (TextIO.stdErr, "Failure opening \"");
         TextIO.output (TextIO.stdErr, inpf_filename);
         TextIO.output (TextIO.stdErr, "\" for input\n");
         OS.Process.exit OS.Process.failure)
  val outf =
      if outf_filename = "-" then
        TextIO.stdOut
      else
        TextIO.openOut outf_filename
        handle
        (IO.Io _) =>
        (TextIO.output (TextIO.stdErr, "Failure opening \"");
         TextIO.output (TextIO.stdErr, outf_filename);
         TextIO.output (TextIO.stdErr, "\" for output\n");
         OS.Process.exit OS.Process.failure)
  val inp = Inp.of_instream inpf
in
  scan_text (outf, inp)
end
handle Unterminated_comment (line_no, column_no) =>
       (TextIO.output (TextIO.stdErr, ": unterminated comment ");
        TextIO.output (TextIO.stdErr, "starting at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | Unterminated_character_literal (line_no, column_no) =>
       (TextIO.output (TextIO.stdErr, ": unterminated character ");
        TextIO.output (TextIO.stdErr, "literal starting at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | Multicharacter_literal (line_no, column_no) =>
       (TextIO.output (TextIO.stdErr, ": unsupported multicharacter");
        TextIO.output (TextIO.stdErr, " literal starting at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | End_of_input_in_string_literal (line_no, column_no) =>
       (TextIO.output (TextIO.stdErr, ": end of input in string");
        TextIO.output (TextIO.stdErr, " literal starting at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | End_of_line_in_string_literal (line_no, column_no) =>
       (TextIO.output (TextIO.stdErr, ": end of line in string");
        TextIO.output (TextIO.stdErr, " literal starting at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | Unsupported_escape (line_no, column_no, c) =>
       (TextIO.output (TextIO.stdErr, CommandLine.name ());
        TextIO.output (TextIO.stdErr, ": unsupported escape \\");
        TextIO.output (TextIO.stdErr, Char.toString c);
        TextIO.output (TextIO.stdErr, " at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | Invalid_integer_literal (line_no, column_no, str) =>
       (TextIO.output (TextIO.stdErr, CommandLine.name ());
        TextIO.output (TextIO.stdErr, ": invalid integer literal ");
        TextIO.output (TextIO.stdErr, str);
        TextIO.output (TextIO.stdErr, " at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure)
     | Unexpected_character (line_no, column_no, c) =>
       (TextIO.output (TextIO.stdErr, CommandLine.name ());
        TextIO.output (TextIO.stdErr, ": unexpected character '");
        TextIO.output (TextIO.stdErr, Char.toString c);
        TextIO.output (TextIO.stdErr, "' at ");
        TextIO.output (TextIO.stdErr, Int.toString line_no);
        TextIO.output (TextIO.stdErr, ":");
        TextIO.output (TextIO.stdErr, Int.toString column_no);
        TextIO.output (TextIO.stdErr, "\n");
        OS.Process.exit OS.Process.failure);

(*------------------------------------------------------------------*)
(* For the Mlton compiler, include the following. For Poly/ML, comment
   it out.  *)
main ();

(*------------------------------------------------------------------*)
(* Instructions for GNU Emacs. *)

(* local variables: *)
(* mode: sml *)
(* sml-indent-level: 2 *)
(* sml-indent-args: 2 *)
(* end: *)
(*------------------------------------------------------------------*)
