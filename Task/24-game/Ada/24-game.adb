with Ada.Float_Text_IO;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
procedure Game_24 is
   subtype Digit is Character range '1' .. '9';
   package Random_Digit is new Ada.Numerics.Discrete_Random (Digit);
   Exp_Error : exception;
   Digit_Generator : Random_Digit.Generator;
   Given_Digits : array (1 .. 4) of Digit;
   Float_Value : constant array (Digit) of Float :=
      (1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0);
   function Apply_Op (L, R : Float; Op : Character) return Float is
   begin
      case Op is
         when '+' =>
            return L + R;
         when '-' =>
            return L - R;
         when '*' =>
            return L * R;
         when '/' =>
            return L / R;
         when others =>
            Ada.Text_IO.Put_Line ("Unexpected operator: " & Op);
            raise Exp_Error;
      end case;
   end Apply_Op;
   function Eval_Exp (E : String) return Float is
      Flt : Float;
      First : Positive := E'First;
      Last : Positive;
      function Match_Paren (Start : Positive) return Positive is
         Pos : Positive := Start + 1;
         Level : Natural := 1;
      begin
         loop
            if Pos > E'Last then
               Ada.Text_IO.Put_Line ("Unclosed parentheses.");
               raise Exp_Error;
            elsif E (Pos) = '(' then
               Level := Level + 1;
            elsif E (Pos) = ')' then
               Level := Level - 1;
               exit when Level = 0;
            end if;
            Pos := Pos + 1;
         end loop;
         return Pos;
      end Match_Paren;
   begin
      if E (First) = '(' then
         Last := Match_Paren (First);
         Flt := Eval_Exp (E (First + 1 .. Last - 1));
      elsif E (First) in Digit then
         Last := First;
         Flt := Float_Value (E (First));
      else
         Ada.Text_IO.Put_Line ("Unexpected character: " & E (First));
         raise Exp_Error;
      end if;
      loop
         if Last = E'Last then
            return Flt;
         elsif Last = E'Last - 1 then
            Ada.Text_IO.Put_Line ("Unexpected end of expression.");
            raise Exp_Error;
         end if;
         First := Last + 2;
         if E (First) = '(' then
            Last := Match_Paren (First);
            Flt := Apply_Op (Flt, Eval_Exp (E (First + 1 .. Last - 1)),
                             Op => E (First - 1));
         elsif E (First) in Digit then
            Last := First;
            Flt := Apply_Op (Flt, Float_Value (E (First)),
                             Op => E (First - 1));
         else
            Ada.Text_IO.Put_Line ("Unexpected character: " & E (First));
            raise Exp_Error;
         end if;
      end loop;
   end Eval_Exp;
begin
   Ada.Text_IO.Put_Line ("24 Game");
   Ada.Text_IO.Put_Line ("- Enter Q to Quit");
   Ada.Text_IO.Put_Line ("- Enter N for New digits");
   Ada.Text_IO.Put_Line ("Note: Operators are evaluated left-to-right");
   Ada.Text_IO.Put_Line ("      (use parentheses to override)");
   Random_Digit.Reset (Digit_Generator);
   <<GEN_DIGITS>>
   Ada.Text_IO.Put_Line ("Generating 4 digits...");
   for I in Given_Digits'Range loop
      Given_Digits (I) := Random_Digit.Random (Digit_Generator);
   end loop;
   <<GET_EXP>>
   Ada.Text_IO.Put ("Your Digits:");
   for I in Given_Digits'Range loop
      Ada.Text_IO.Put (" " & Given_Digits (I));
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put ("Enter your Expression: ");
   declare
      Value : Float;
      Response : constant String := Ada.Text_IO.Get_Line;
      Prev_Ch : Character := ' ';
      Unused_Digits : array (Given_Digits'Range) of Boolean :=
        (others => True);
   begin
      if Response = "n" or Response = "N" then
         goto GEN_DIGITS;
      end if;
      if Response = "q" or Response = "Q" then
         return;
      end if;
      -- check input
      for I in Response'Range loop
         declare
            Ch : constant Character := Response (I);
            Found : Boolean;
         begin
            if Ch in Digit then
               if Prev_Ch in Digit then
                  Ada.Text_IO.Put_Line ("Illegal multi-digit number used.");
                  goto GET_EXP;
               end if;
               Found := False;
               for J in Given_Digits'Range loop
                  if Unused_Digits (J) and then
                        Given_Digits (J) = Ch then
                     Unused_Digits (J) := False;
                     Found := True;
                     exit;
                  end if;
               end loop;
               if not Found then
                  Ada.Text_IO.Put_Line ("Illegal number used: " & Ch);
                  goto GET_EXP;
               end if;
            elsif Ch /= '(' and Ch /= ')' and Ch /= '+' and
                  Ch /= '-' and Ch /= '*' and Ch /= '/' then
               Ada.Text_IO.Put_Line ("Illegal character used: " & Ch);
               goto GET_EXP;
            end if;
            Prev_Ch := Ch;
         end;
      end loop;
      -- check all digits used
      for I in Given_Digits'Range loop
         if Unused_Digits (I) then
            Ada.Text_IO.Put_Line ("Digit not used: " & Given_Digits (I));
            goto GET_EXP;
         end if;
      end loop;
      -- check value
      begin
         Value := Eval_Exp (Response);
      exception
         when Exp_Error =>
            goto GET_EXP; -- Message displayed by Eval_Exp;
      end;
      if abs (Value - 24.0) > 0.001 then
         Ada.Text_IO.Put ("Value ");
         Ada.Float_Text_IO.Put (Value, Fore => 0, Aft => 3, Exp => 0);
         Ada.Text_IO.Put_Line (" is not 24!");
         goto GET_EXP;
      else
         Ada.Text_IO.Put_Line ("You won!");
         Ada.Text_IO.Put_Line ("Enter N for a new game, or try another solution.");
         goto GET_EXP;
      end if;
   end;
end Game_24;
