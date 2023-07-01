with Ada.Text_IO, Ada.Streams.Stream_IO, Ada.Strings.Unbounded, Ada.Command_Line,
     Ada.Exceptions;
use Ada.Strings, Ada.Strings.Unbounded, Ada.Streams, Ada.Exceptions;

procedure Main is
   package IO renames Ada.Text_IO;

   package Lexer is
      type Token is (Op_multiply, Op_divide, Op_mod, Op_add, Op_subtract, Op_negate,
                     Op_less, Op_lessequal, Op_greater, Op_greaterequal, Op_equal,
                     Op_notequal, Op_not, Op_assign, Op_and, Op_or,

                     LeftParen, RightParen, LeftBrace, RightBrace, Semicolon, Comma,

                     Keyword_if, Keyword_else, Keyword_while, Keyword_print, Keyword_putc,
                     Identifier, Token_Integer, Token_String, End_of_input,

                     Empty_Char_Error, Invalid_Escape_Error, Multi_Char_Error, EOF_Comment_Error,
                     EOF_String_Error, EOL_String_Error, Invalid_Char_Error, Invalid_Num_Error
                    );

      subtype Operator is Token range Op_multiply .. Op_or;
      subtype Symbol is Token range Token'Succ(Operator'Last) .. Comma;
      subtype Keyword is Token range Token'Succ(Symbol'Last) .. Keyword_putc;
      subtype Error is Token range Empty_Char_Error .. Invalid_Num_Error;
      subtype Operator_or_Error is Token
        with Static_Predicate => Operator_or_Error in Operator | Error;

      subtype Whitespace is Character
        with Static_Predicate => Whitespace in ' ' | ASCII.HT | ASCII.CR | ASCII.LF;

      Lexer_Error : exception;
      Invalid_Escape_Code : constant Character := ASCII.NUL;

      procedure run(input : Stream_IO.File_Type);
   end Lexer;

   package body Lexer is
      use type Stream_IO.Count;

      procedure run(input : Stream_IO.File_Type) is
         type State is (State_Start, State_Identifier, State_Integer, State_Char, State_String,
                        State_Comment);
         curr_state : State := State_Start;
         curr_char : Character;
         curr_col, curr_row, token_col, token_row : Positive := 1;
         token_text : Unbounded_String := Unbounded.Null_Unbounded_String;

         function look_ahead return Character is
            next_char : Character := ASCII.LF;
         begin
            if not Stream_IO.End_Of_File(input) then
               next_char := Character'Input(Stream_IO.Stream(input));
               Stream_IO.Set_Index(input, Stream_IO.Index(input) - 1);
            end if;
            return next_char;
         end look_ahead;

         procedure next_char is
            next : Character := Character'Input(Stream_IO.Stream(input));
         begin
            curr_col := curr_col + 1;
            if curr_char = ASCII.LF then
               curr_row := curr_row + 1;
               curr_col := 1;
            end if;
            curr_char := next;
         end next_char;

         procedure print_token(tok : Token; text : String := "") is
            procedure raise_error(text : String) is
            begin
               raise Lexer_Error with "Error: " & text;
            end;
         begin
            IO.Put(token_row'Image & ASCII.HT & token_col'Image & ASCII.HT);
            case tok is
               when Operator | Symbol | Keyword | End_of_input => IO.Put_Line(tok'Image);
               when Token_Integer => IO.Put_Line("INTEGER" & ASCII.HT & text);
               when Token_String  => IO.Put_Line("STRING" & ASCII.HT & ASCII.Quotation & text & ASCII.Quotation);
               when Identifier    => IO.Put_Line(tok'Image & ASCII.HT & text);
               when Empty_Char_Error => raise_error("empty character constant");
               when Invalid_Escape_Error => raise_error("unknown escape sequence: " & text);
               when Multi_Char_Error => raise_error("multi-character constant: " & text);
               when EOF_Comment_Error => raise_error("EOF in comment");
               when EOF_String_Error => raise_error("EOF in string");
               when EOL_String_Error => raise_error("EOL in string");
               when Invalid_Char_Error => raise_error("invalid character: " & curr_char);
               when Invalid_Num_Error => raise_error("invalid number: " & text);
            end case;
         end print_token;

         procedure lookahead_choose(determiner : Character; a, b : Operator_or_Error) is
         begin
            if look_ahead = determiner then
               print_token(a);
               next_char;
            else
               print_token(b);
            end if;
         end lookahead_choose;

         function to_escape_code(c : Character) return Character is
         begin
            case c is
               when 'n' => return ASCII.LF;
               when '\' => return '\';
               when others =>
                  print_token(Invalid_Escape_Error, ASCII.Back_Slash & c);
                  return Invalid_Escape_Code;
            end case;
         end to_escape_code;
      begin
         curr_char := Character'Input(Stream_IO.Stream(input));
         loop
            case curr_state is
               when State_Start =>
                  token_col := curr_col;
                  token_row := curr_row;
                  case curr_char is
                     when '*' => print_token(Op_multiply);
                     when '/' =>
                        if look_ahead = '*' then
                           next_char;
                           curr_state := State_Comment;
                        else
                           print_token(Op_divide);
                        end if;
                     when '%' => print_token(Op_mod);
                     when '+' => print_token(Op_add);
                     when '-' => print_token(Op_subtract);
                     when '(' => print_token(LeftParen);
                     when ')' => print_token(RightParen);
                     when '{' => print_token(LeftBrace);
                     when '}' => print_token(RightBrace);
                     when ';' => print_token(Semicolon);
                     when ',' => print_token(Comma);
                     when '<' => lookahead_choose('=', Op_lessequal, Op_less);
                     when '>' => lookahead_choose('=', Op_greaterequal, Op_greater);
                     when '!' => lookahead_choose('=', Op_notequal, Op_not);
                     when '=' => lookahead_choose('=', Op_equal, Op_assign);
                     when '&' => lookahead_choose('&', Op_and, Invalid_Char_Error);
                     when '|' => lookahead_choose('|', Op_or, Invalid_Char_Error);
                     when 'a' .. 'z' | 'A' .. 'Z' | '_' =>
                        Unbounded.Append(token_text, curr_char);
                        curr_state := State_Identifier;
                     when '0' .. '9' =>
                        Unbounded.Append(token_text, curr_char);
                        curr_state := State_Integer;
                     when ''' => curr_state := State_Char;
                     when ASCII.Quotation => curr_state := State_String;
                     when Whitespace => null;
                     when others => null;
                  end case;
                  next_char;

               when State_Identifier =>
                  case curr_char is
                     when 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' =>
                        Unbounded.Append(token_text, curr_char);
                        next_char;
                     when others =>
                        if token_text = "if" then
                           print_token(Keyword_if);
                        elsif token_text = "else" then
                           print_token(Keyword_else);
                        elsif token_text = "while" then
                           print_token(Keyword_while);
                        elsif token_text = "print" then
                           print_token(Keyword_print);
                        elsif token_text = "putc" then
                           print_token(Keyword_putc);
                        else
                           print_token(Identifier, To_String(token_text));
                        end if;
                        Unbounded.Set_Unbounded_String(token_text, "");
                        curr_state := State_Start;
                  end case;

               when State_Integer =>
                  case curr_char is
                     when '0' .. '9' =>
                        Unbounded.Append(token_text, curr_char);
                        next_char;
                     when 'a' .. 'z' | 'A' .. 'Z' | '_' =>
                        print_token(Invalid_Num_Error, To_String(token_text));
                     when others =>
                        print_token(Token_Integer, To_String(token_text));
                        Unbounded.Set_Unbounded_String(token_text, "");
                        curr_state := State_Start;
                  end case;

               when State_Char =>
                  case curr_char is
                     when ''' =>
                        if Unbounded.Length(token_text) = 0 then
                           print_token(Empty_Char_Error);
                        elsif Unbounded.Length(token_text) = 1 then
                           print_token(Token_Integer, Character'Pos(Element(token_text, 1))'Image);
                        else
                           print_token(Multi_Char_Error, To_String(token_text));
                        end if;
                        Set_Unbounded_String(token_text, "");
                        curr_state := State_Start;
                     when '\' =>
                        Unbounded.Append(token_text, to_escape_code(look_ahead));
                        next_char;
                     when others => Unbounded.Append(token_text, curr_char);
                  end case;
                  next_char;

               when State_String =>
                  case curr_char is
                     when ASCII.Quotation =>
                        print_token(Token_String, To_String(token_text));
                        Set_Unbounded_String(token_text, "");
                        curr_state := State_Start;
                     when '\' =>
                        if to_escape_code(look_ahead) /= Invalid_Escape_Code then
                           Unbounded.Append(token_text, curr_char);
                        end if;
                     when ASCII.LF | ASCII.CR => print_token(EOL_String_Error);
                     when others => Unbounded.Append(token_text, curr_char);
                  end case;
                  next_char;

               when State_Comment =>
                  case curr_char is
                     when '*' =>
                        if look_ahead = '/' then
                           next_char;
                           curr_state := State_Start;
                        end if;
                     when others => null;
                  end case;
                  next_char;
            end case;
         end loop;
      exception
         when error : Stream_IO.End_Error =>
            if curr_state = State_String then
               print_token(EOF_String_Error);
            else
               print_token(End_of_input);
            end if;
         when error : Lexer.Lexer_Error => IO.Put_Line(Exception_Message(error));
      end run;
   end Lexer;

   source_file : Stream_IO.File_Type;
begin
   if Ada.Command_Line.Argument_Count < 1 then
      IO.Put_Line("usage: lex [filename]");
      return;
   end if;
   Stream_IO.Open(source_file, Stream_IO.In_File, Ada.Command_Line.Argument(1));
   Lexer.run(source_file);
exception
   when error : others => IO.Put_Line("Error: " & Exception_Message(error));
end Main;
