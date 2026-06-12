with Ada.Exceptions;         use Ada.Exceptions;
with Ada.Text_IO;            use Ada.Text_IO;
with Unbounded_Rationals;    use  Unbounded_Rationals;
with Parsers.String_Source;  use Parsers.String_Source;

with Strings_Edit.Unbounded_Rational_Edit;
use  Strings_Edit.Unbounded_Rational_Edit;

with Parsers.Generic_Lexer.Blanks;
with Parsers.Generic_Token.Segmented_Lexer;

with Tables.Names;

procedure Rational_Calculator is
--
-- Operations -- The operations supported
--
   type Operations is
        (  Add, Sub, Mul, Div,           -- Infix operators
           Abs_Value, Plus, Minus,       -- Prefix operators
           Left_Bracket, Right_Bracket   -- Brackets
        );
--
-- "and" -- Checks operation associations, always True (Ok)
--
   function "and" (Left, Right : Operations) return Boolean is (True);
--
-- Is_Commutative -- No commutative operations, always False
--
   function Is_Commutative (Left, Right : Operations)
      return Boolean is (False);
--
-- Is_Inverse -- No commutative operations, always False
--
   function Is_Inverse (Operation : Operations)
      return Boolean is (False);
--
-- Group_Inverse -- No commutative operations, never called
--
   function Group_Inverse (Operation : Operations)
      return Operations is (Minus);
--
-- Priorities -- The levels of association
--
   type Priorities is mod 10;
--
-- Tokens -- The lexical tokens
--
   package Tokens is
      new Parsers.Generic_Token
          (  Operation_Type => Operations,
             Argument_Type  => Unbounded_Rational,
             Priority_Type  => Priorities,
             Sources        => Code
          );
   use Tokens;
--
-- Check_Spelling -- Of a name, no checks
--
   procedure Check_Spelling (Name : String) is null;
--
-- Check_Matched -- Check if no broken keyword matched
--
   function Check_Matched (Source : String; Pointer : Integer)
      return Boolean is (
         Source (Pointer    ) not in '0'..'9' | 'A'..'Z' | 'a'..'z'
      or else
         Source (Pointer - 1) not in '0'..'9' | 'A'..'Z' | 'a'..'z');
--
-- Token_Tables -- Case-insensitive  tables of tokens we have no Unicode
--                 keyword, so ASCII version is OK
--
   package Token_Tables is new Tokens.Vocabulary.Names;
--
-- The tables of prefix, infix and postfix operations
--
   Prefixes  : aliased Token_Tables.Dictionary;
   Infixes   : aliased Token_Tables.Dictionary;
   Postfixes : aliased Token_Tables.Dictionary;
--
-- Lexers -- Table driven lexers
--
   package Lexers is new Tokens.Segmented_Lexer;
--
-- Blank_Skipping_Lexers -- Ones that skip blanks
--
   package Blank_Skipping_Lexers is
      new Lexers.Token_Lexer.Implementation.Blanks (Lexers.Lexer);
--
-- Expression -- The lexer using our tables
--
   type Expression is
      new Blank_Skipping_Lexers.Lexer
          (  Prefixes  => Prefixes'Access,
             Infixes   => Infixes'Access,
             Postfixes => Postfixes'Access
          )  with null record;
   overriding
      function Enclose
               (  Context : access Expression;
                  Left    : Tokens.Operation_Token;
                  Right   : Tokens.Operation_Token;
                  List    : Tokens.Arguments.Frame
               )  return Tokens.Argument_Token;
--
-- Call -- Evaluates an operator
--
   overriding
      function Call
               (  Context   : access Expression;
                  Operation : Tokens.Operation_Token;
                  List      : Tokens.Arguments.Frame
               )  return Tokens.Argument_Token;
   overriding
      procedure Get_Operand
                (  Context  : in out Expression;
                   Code     : in out Source;
                   Argument : out Tokens.Argument_Token;
                   Got_It   : out Boolean
                );
--
-- Enclose -- Evaluates an expression in brackets, returns the argument
--
   function Enclose
            (  Context : access Expression;
               Left    : Tokens.Operation_Token;
               Right   : Tokens.Operation_Token;
               List    : Tokens.Arguments.Frame
            )  return Tokens.Argument_Token is
   begin
      return
      (  List (List'First).Value,
         Left.Location & Right.Location
      );
   end Enclose;
--
-- Call -- Evaluates an operator
--
   function Call
            (  Context   : access Expression;
               Operation : Tokens.Operation_Token;
               List      : Tokens.Arguments.Frame
            )  return Tokens.Argument_Token is
      Result : Unbounded_Rational;
   begin
      case Operation.Operation is
         when Abs_Value =>
            Result := abs List (List'First).Value;
         when Add =>
            Result := List (List'First).Value + List (List'Last).Value;
         when Sub =>
            Result := List (List'First).Value - List (List'Last).Value;
         when Mul =>
            Result := List (List'First).Value * List (List'Last).Value;
         when Div =>
            if List (List'Last).Value = 0 then
               raise Numeric_Error with
                     "Zero divisor at " &
                     Image (List (List'Last).Location);
            end if;
            Result := List (List'First).Value / List (List'Last).Value;
         when Plus =>
            Result := List (List'First).Value;
         when Minus =>
            Result := -List (List'First).Value;
         when others =>
            raise Program_Error;
      end case;
      return (Result, Operation.Location & Link (List));
   end Call;

   Old_Value : Unbounded_Rational := Zero;
--
-- Get_Operand -- Recognizes an operand (rational number)
--
   procedure Get_Operand
             (  Context  : in out Expression;
                Code     : in out Source;
                Argument : out Tokens.Argument_Token;
                Got_It   : out Boolean
             )  is
      Line    : String renames Get_Line (Code);
      Pointer : Integer := Get_Pointer (Code);
      Value   : Unbounded_Rational;
   begin
      if Pointer <= Line'Last and then Line (Pointer) = '@' then
         Pointer := Pointer + 1;
         Set_Pointer (Code, Pointer);
         Argument := (Old_Value, Link (Code));
      else
         Get_Recurring (Line, Pointer, Value);
         Set_Pointer (Code, Pointer);
         Argument := (Value, Link (Code));
      end if;
      Got_It := True;
   exception
      when End_Error =>
         raise Numeric_Error with
               "Number or @ expected at " & Image (Link (Code));
      when Constraint_Error =>
         Set_Pointer (Code, Pointer);
         raise Numeric_Error with
               "Too large number at " & Image (Link (Code));
      when Data_Error =>
         Set_Pointer (Code, Pointer);
         raise Parsers.Syntax_Error with
               "Wrong number at " & Image (Link (Code));
   end Get_Operand;

   Reckoner : Expression;
begin --                 operation         left  right priority
   Add_Operator (Prefixes, "abs", Abs_Value,  8, 7);
   Add_Operator (Prefixes, "+",   Plus,       8, 7);
   Add_Operator (Prefixes, "-",   Minus,      8, 7);
   Add_Bracket  (Prefixes, "(",   Left_Bracket);

   Add_Operator (Infixes, "+",  Add, 1, 2);
   Add_Operator (Infixes, "-",  Sub, 1, 3);
   Add_Operator (Infixes, "*",  Mul, 3, 4);
   Add_Operator (Infixes, "/",  Div, 3, 4);

   Add_Bracket  (Postfixes, ")", Right_Bracket);

   Put_Line ("Enter empty line to exit");
   loop
      Put (">");
      declare
         Formula : aliased String := Get_Line;
         Code    : Source (Formula'Access);
         Result  : Tokens.Argument_Token;
      begin
         exit when Formula'Length = 0;
         Lexers.Parse (Reckoner, Code, Result);
         if Get_Pointer (Code) <= Formula'Last then
            raise Parsers.Syntax_Error with
                  "Unrecognized '" &
                  Formula (Get_Pointer (Code)..Formula'Last) & "'";
         end if;
         Old_Value := Result.Value;
         Put_Line ("=" & Image_Recurring (Result.Value));
      exception
         when Error : Numeric_Error | Parsers.Syntax_Error =>
            Put_Line (Exception_Message (Error));
      end;
   end loop;
end Rational_Calculator;
