#!/bin/env escript
%%%-------------------------------------------------------------------

-record (inp_t, {inpf, pushback, line_no, column_no}).

main (Args) ->
   main_program (Args).

main_program ([]) ->
   scan_from_inpf_to_outf ("-", "-"),
   halt (0);
main_program ([Inpf_filename]) ->
   scan_from_inpf_to_outf (Inpf_filename, "-"),
   halt (0);
main_program ([Inpf_filename, Outf_filename]) ->
   scan_from_inpf_to_outf (Inpf_filename, Outf_filename),
   halt (0);
main_program ([_, _ | _]) ->
   ProgName = escript:script_name (),
   io:put_chars (standard_error, "Usage: "),
   io:put_chars (standard_error, ProgName),
   io:put_chars (standard_error, " [INPUTFILE [OUTPUTFILE]]\n"),
   halt (1).

scan_from_inpf_to_outf ("-", "-") ->
   scan_input (standard_io, standard_io);
scan_from_inpf_to_outf (Inpf_filename, "-") ->
   case file:open (Inpf_filename, [read]) of
      {ok, Inpf} -> scan_input (Inpf, standard_io);
      _ -> open_failure (Inpf_filename, "input")
   end;
scan_from_inpf_to_outf ("-", Outf_filename) ->
   case file:open (Outf_filename, [write]) of
      {ok, Outf} -> scan_input (standard_io, Outf);
      _ -> open_failure (Outf_filename, "output")
   end;
scan_from_inpf_to_outf (Inpf_filename, Outf_filename) ->
   case file:open(Inpf_filename, [read]) of
      {ok, Inpf} ->
         case file:open (Outf_filename, [write]) of
            {ok, Outf} -> scan_input (Inpf, Outf);
            _ -> open_failure (Outf_filename, "output")
         end;
      _ -> open_failure (Inpf_filename, "input")
   end.

open_failure (Filename, ForWhat) ->
   ProgName = escript:script_name (),
   io:put_chars (standard_error, ProgName),
   io:put_chars (standard_error, ": failed to open \""),
   io:put_chars (standard_error, Filename),
   io:put_chars (standard_error, "\" for "),
   io:put_chars (standard_error, ForWhat),
   io:put_chars (standard_error, "\n"),
   halt (1).

scan_input (Inpf, Outf) ->
   scan_text (Outf, make_inp (Inpf)).

scan_text (Outf, Inp) ->
   {TokTup, Inp1} = get_next_token (Inp),
   print_token (Outf, TokTup),
   case TokTup of
      {"End_of_input", _, _, _} -> ok;
      _ -> scan_text (Outf, Inp1)
   end.

print_token (Outf, {Tok, Arg, Line_no, Column_no}) ->
   S_line_no = erlang:integer_to_list (Line_no),
   S_column_no = erlang:integer_to_list (Column_no),
   io:put_chars (Outf, string:pad (S_line_no, 5, leading)),
   io:put_chars (Outf, " "),
   io:put_chars (Outf, string:pad (S_column_no, 5, leading)),
   io:put_chars (Outf, "  "),
   io:put_chars (Outf, Tok),
   {Padding, Arg1} =
      case Tok of
         "Identifier" -> {"     ", Arg};
         "Integer" -> {"        ", Arg};
         "String" -> {"         ", Arg};
         _ -> {"", ""}
      end,
   io:put_chars (Outf, Padding),
   io:put_chars (Outf, Arg1),
   io:put_chars ("\n").

%%%-------------------------------------------------------------------
%%%
%%% The token dispatcher.
%%%

get_next_token (Inp) ->
   Inp00 = skip_spaces_and_comments (Inp),
   {Ch, Inp0} = get_ch (Inp00),
   {Char, Line_no, Column_no} = Ch,
   Ln = Line_no,
   Cn = Column_no,
   case Char of
      eof -> {{"End_of_input", "", Ln, Cn}, Inp0};
      "," -> {{"Comma", ",", Ln, Cn}, Inp0};
      ";" -> {{"Semicolon", ";", Ln, Cn}, Inp0};
      "(" -> {{"LeftParen", "(", Ln, Cn}, Inp0};
      ")" -> {{"RightParen", ")", Ln, Cn}, Inp0};
      "{" -> {{"LeftBrace", "{", Ln, Cn}, Inp0};
      "}" -> {{"RightBrace", "}", Ln, Cn}, Inp0};
      "*" -> {{"Op_multiply", "*", Ln, Cn}, Inp0};
      "/" -> {{"Op_divide", "/", Ln, Cn}, Inp0};
      "%" -> {{"Op_mod", "%", Ln, Cn}, Inp0};
      "+" -> {{"Op_add", "+", Ln, Cn}, Inp0};
      "-" -> {{"Op_subtract", "-", Ln, Cn}, Inp0};
      "<" ->
         {Ch1, Inp1} = get_ch (Inp0),
         {Char1, _, _} = Ch1,
         case Char1 of
            "=" -> {{"Op_lessequal", "<=", Ln, Cn}, Inp1};
            _ -> {{"Op_less", "<", Ln, Cn}, push_back (Ch1, Inp1)}
         end;
      ">" ->
         {Ch1, Inp1} = get_ch (Inp0),
         {Char1, _, _} = Ch1,
         case Char1 of
            "=" -> {{"Op_greaterequal", ">=", Ln, Cn}, Inp1};
            _ -> {{"Op_greater", ">", Ln, Cn}, push_back (Ch1, Inp1)}
         end;
      "=" ->
         {Ch1, Inp1} = get_ch (Inp0),
         {Char1, _, _} = Ch1,
         case Char1 of
            "=" -> {{"Op_equal", "==", Ln, Cn}, Inp1};
            _ -> {{"Op_assign", "=", Ln, Cn}, push_back (Ch1, Inp1)}
         end;
      "!" ->
         {Ch1, Inp1} = get_ch (Inp0),
         {Char1, _, _} = Ch1,
         case Char1 of
            "=" -> {{"Op_notequal", "!=", Ln, Cn}, Inp1};
            _ -> {{"Op_not", "!", Ln, Cn}, push_back (Ch1, Inp1)}
         end;
      "&" ->
         {Ch1, Inp1} = get_ch (Inp0),
         {Char1, _, _} = Ch1,
         case Char1 of
            "&" -> {{"Op_and", "&&", Ln, Cn}, Inp1};
            _ -> unexpected_character (Ln, Cn, Char)
         end;
      "|" ->
         {Ch1, Inp1} = get_ch (Inp0),
         {Char1, _, _} = Ch1,
         case Char1 of
            "|" -> {{"Op_or", "||", Ln, Cn}, Inp1};
            _ -> unexpected_character (Ln, Cn, Char)
         end;
      "\"" ->
         Inp1 = push_back (Ch, Inp0),
         scan_string_literal (Inp1);
      "'" ->
         Inp1 = push_back (Ch, Inp0),
         scan_character_literal (Inp1);
      _ ->
         case is_digit (Char) of
            true ->
               Inp1 = push_back (Ch, Inp0),
               scan_integer_literal (Inp1);
            false ->
               case is_alpha_or_underscore (Char) of
                  true ->
                     Inp1 = push_back (Ch, Inp0),
                     scan_identifier_or_reserved_word (Inp1);
                  false ->
                     unexpected_character (Ln, Cn, Char)
               end
         end
   end.

%%%-------------------------------------------------------------------
%%%
%%% Skipping past spaces and /* ... */ comments.
%%%
%%% Comments are treated exactly like a bit of whitespace. They never
%%% make it to the dispatcher.
%%%

skip_spaces_and_comments (Inp) ->
   {Ch, Inp0} = get_ch (Inp),
   {Char, Line_no, Column_no} = Ch,
   case classify_char (Char) of
      eof -> push_back (Ch, Inp0);
      space -> skip_spaces_and_comments (Inp0);
      slash ->
         {Ch1, Inp1} = get_ch (Inp0),
         case Ch1 of
            {"*", _, _} ->
               Inp2 = scan_comment (Inp1, Line_no, Column_no),
               skip_spaces_and_comments (Inp2);
            _ -> push_back (Ch, (push_back (Ch1, Inp1)))
         end;
      other -> push_back (Ch, Inp0)
   end.

classify_char (Char) ->
   case Char of
      eof -> eof;
      "/" -> slash;
      _ -> case is_space (Char) of
              true -> space;
              false -> other
           end
   end.

scan_comment (Inp, Line_no, Column_no) ->
   {Ch0, Inp0} = get_ch (Inp),
   case Ch0 of
      {eof, _, _} -> unterminated_comment (Line_no, Column_no);
      {"*", _, _} ->
         {Ch1, Inp1} = get_ch (Inp0),
         case Ch1 of
            {eof, _, _} ->
               unterminated_comment (Line_no, Column_no);
            {"/", _, _} -> Inp1;
            _ -> scan_comment (Inp1, Line_no, Column_no)
         end;
      _ -> scan_comment (Inp0, Line_no, Column_no)
   end.

is_space (S) ->
   case re:run (S, "^[[:space:]]+$") of
      {match, _} -> true;
      _ -> false
   end.

%%%-------------------------------------------------------------------
%%%
%%% Scanning of integer literals, identifiers, and reserved words.
%%%
%%% These three types of token are very similar to each other.
%%%

scan_integer_literal (Inp) ->
   %% Scan an entire word, not just digits. This way we detect
   %% erroneous text such as "23skidoo".
   {Line_no, Column_no, Inp1} = get_position (Inp),
   {Word, Inp2} = scan_word (Inp1),
   case is_digit (Word) of
      true -> {{"Integer", Word, Line_no, Column_no}, Inp2};
      false -> invalid_integer_literal (Line_no, Column_no, Word)
   end.

scan_identifier_or_reserved_word (Inp) ->
   %% It is assumed that the first character is of the correct type,
   %% thanks to the dispatcher.
   {Line_no, Column_no, Inp1} = get_position (Inp),
   {Word, Inp2} = scan_word (Inp1),
   Tok =
      case Word of
         "if" -> "Keyword_if";
         "else" -> "Keyword_else";
         "while" -> "Keyword_while";
         "print" -> "Keyword_print";
         "putc" -> "Keyword_putc";
         _ -> "Identifier"
      end,
   {{Tok, Word, Line_no, Column_no}, Inp2}.

scan_word (Inp) ->
   scan_word_loop (Inp, "").

scan_word_loop (Inp, Word0) ->
   {Ch1, Inp1} = get_ch (Inp),
   {Char1, _, _} = Ch1,
   case is_alnum_or_underscore (Char1) of
      true -> scan_word_loop (Inp1, Word0 ++ Char1);
      false -> {Word0, push_back (Ch1, Inp1)}
   end.

get_position (Inp) ->
   {Ch1, Inp1} = get_ch (Inp),
   {_, Line_no, Column_no} = Ch1,
   Inp2 = push_back (Ch1, Inp1),
   {Line_no, Column_no, Inp2}.

is_digit (S) ->
   case re:run (S, "^[[:digit:]]+$") of
      {match, _} -> true;
      _ -> false
   end.

is_alpha_or_underscore (S) ->
   case re:run (S, "^[[:alpha:]_]+$") of
      {match, _} -> true;
      _ -> false
   end.

is_alnum_or_underscore (S) ->
   case re:run (S, "^[[:alnum:]_]+$") of
      {match, _} -> true;
      _ -> false
   end.

%%%-------------------------------------------------------------------
%%%
%%% Scanning of string literals.
%%%
%%% It is assumed that the first character is the opening quote, and
%%% that the closing quote is the same character.
%%%


scan_string_literal (Inp) ->
   {Ch1, Inp1} = get_ch (Inp),
   {Quote_mark, Line_no, Column_no} = Ch1,
   {Contents, Inp2} = scan_str_lit (Inp1, Ch1),
   Toktup = {"String", Quote_mark ++ Contents ++ Quote_mark,
             Line_no, Column_no},
   {Toktup, Inp2}.

scan_str_lit (Inp, Ch) -> scan_str_lit_loop (Inp, Ch, "").

scan_str_lit_loop (Inp, Ch, Contents) ->
   {Quote_mark, Line_no, Column_no} = Ch,
   {Ch1, Inp1} = get_ch (Inp),
   {Char1, Line_no1, Column_no1} = Ch1,
   case Char1 of
      Quote_mark -> {Contents, Inp1};
      eof -> eoi_in_string_literal (Line_no, Column_no);
      "\n" -> eoln_in_string_literal (Line_no, Column_no);
      "\\" ->
         {Ch2, Inp2} = get_ch (Inp1),
         {Char2, _, _} = Ch2,
         case Char2 of
            "n" ->
               scan_str_lit_loop (Inp2, Ch, Contents ++ "\\n");
            "\\" ->
               scan_str_lit_loop (Inp2, Ch, Contents ++ "\\\\");
            _ ->
               unsupported_escape (Line_no1, Column_no1, Char2)
         end;
      _ -> scan_str_lit_loop (Inp1, Ch, Contents ++ Char1)
   end.

%%%-------------------------------------------------------------------
%%%
%%% Scanning of character literals.
%%%
%%% It is assumed that the first character is the opening quote, and
%%% that the closing quote is the same character.
%%%
%%% The tedious part of scanning a character literal is distinguishing
%%% between the kinds of lexical error. (One might wish to modify the
%%% code to detect, as a distinct kind of error, end of line within a
%%% character literal.)
%%%

scan_character_literal (Inp) ->
   {Ch, Inp0} = get_ch (Inp),
   {_, Line_no, Column_no} = Ch,
   {Ch1, Inp1} = get_ch (Inp0),
   {Char1, Line_no1, Column_no1} = Ch1,
   {Intval, Inp3} =
      case Char1 of
         eof -> unterminated_character_literal (Line_no, Column_no);
         "\\" ->
            {Ch2, Inp2} = get_ch (Inp1),
            {Char2, _, _} = Ch2,
            case Char2 of
               eof -> unterminated_character_literal (Line_no,
                                                      Column_no);
               "n" -> {char_to_code ("\n"), Inp2};
               "\\" -> {char_to_code ("\\"), Inp2};
               _ -> unsupported_escape (Line_no1, Column_no1,
                                        Char2)
            end;
         _ -> {char_to_code (Char1), Inp1}
      end,
   Inp4 = check_character_literal_end (Inp3, Ch),
   {{"Integer", Intval, Line_no, Column_no}, Inp4}.

char_to_code (Char) ->
   %% Hat tip to https://archive.ph/BxZRS
   lists:flatmap (fun erlang:integer_to_list/1, Char).

check_character_literal_end (Inp, Ch) ->
   {Char, _, _} = Ch,
   {{Char1, _, _}, Inp1} = get_ch (Inp),
   case Char1 of
      Char -> Inp1;
      _ -> find_char_lit_end (Inp1, Ch)    % Handle a lexical error.
   end.

find_char_lit_end (Inp, Ch) ->
   %% There is a lexical error. Determine which kind it fits into.
   {Char, Line_no, Column_no} = Ch,
   {{Char1, _, _}, Inp1} = get_ch (Inp),
   case Char1 of
      Char -> multicharacter_literal (Line_no, Column_no);
      eof -> unterminated_character_literal (Line_no, Column_no);
      _ -> find_char_lit_end (Inp1, Ch)
   end.

%%%-------------------------------------------------------------------
%%%
%%% Character-at-a-time input, with unrestricted pushback, and with
%%% line and column numbering.
%%%

make_inp (Inpf) ->
   #inp_t{inpf = Inpf,
          pushback = [],
          line_no = 1,
          column_no = 1}.

get_ch (Inp) ->
   #inp_t{inpf = Inpf,
          pushback = Pushback,
          line_no = Line_no,
          column_no = Column_no} = Inp,
   case Pushback of
      [Ch | Tail] ->
         Inp1 = Inp#inp_t{pushback = Tail},
         {Ch, Inp1};
      [] ->
         case io:get_chars (Inpf, "", 1) of
            eof ->
               Ch = {eof, Line_no, Column_no},
               {Ch, Inp};
            {error, _} ->
               Ch = {eof, Line_no, Column_no},
               {Ch, Inp};
            Char ->
               case Char of
                  "\n" ->
                     Ch = {Char, Line_no, Column_no},
                     Inp1 = Inp#inp_t{line_no = Line_no + 1,
                                      column_no = 1},
                     {Ch, Inp1};
                  _ ->
                     Ch = {Char, Line_no, Column_no},
                     Inp1 =
                        Inp#inp_t{column_no = Column_no + 1},
                     {Ch, Inp1}
               end
         end
   end.

push_back (Ch, Inp) ->
   Inp#inp_t{pushback = [Ch | Inp#inp_t.pushback]}.

%%%-------------------------------------------------------------------

invalid_integer_literal (Line_no, Column_no, Word) ->
   error_abort ("invalid integer literal \"" ++
                   Word ++ "\" at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

unsupported_escape (Line_no, Column_no, Char) ->
   error_abort ("unsupported escape \\" ++
                   Char ++ " at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

unexpected_character (Line_no, Column_no, Char) ->
   error_abort ("unexpected character '" ++
                   Char ++ "' at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

eoi_in_string_literal (Line_no, Column_no) ->
   error_abort ("end of input in string literal starting at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

eoln_in_string_literal (Line_no, Column_no) ->
   error_abort ("end of line in string literal starting at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

unterminated_character_literal (Line_no, Column_no) ->
   error_abort ("unterminated character literal starting at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

multicharacter_literal (Line_no, Column_no) ->
   error_abort ("unsupported multicharacter literal starting at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

unterminated_comment (Line_no, Column_no) ->
   error_abort ("unterminated comment starting at " ++
                   integer_to_list (Line_no) ++ ":" ++
                   integer_to_list (Column_no)).

error_abort (Message) ->
   ProgName = escript:script_name (),
   io:put_chars (standard_error, ProgName),
   io:put_chars (standard_error, ": "),
   io:put_chars (standard_error, Message),
   io:put_chars (standard_error, "\n"),
   halt (1).

%%%-------------------------------------------------------------------
%%% Instructions to GNU Emacs --
%%% local variables:
%%% mode: erlang
%%% erlang-indent-level: 3
%%% end:
%%%-------------------------------------------------------------------
