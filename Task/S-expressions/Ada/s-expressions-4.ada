with Ada.Integer_Text_IO, Ada.Float_Text_IO;

package body S_Expr.Parser is

   function Parse(Input: String) return List_Of_Data is

      procedure First_Token(S: String;
                            Start_Of_Token, End_Of_Token: out Positive) is
      begin
         Start_Of_Token := S'First;
         while Start_Of_Token <= S'Last and then S(Start_Of_Token) = ' ' loop
            Start_Of_Token := Start_Of_Token + 1; -- skip spaces
         end loop;
         if Start_Of_Token > S'Last then
            End_Of_Token := Start_Of_Token - 1;
            -- S(Start_Of_Token .. End_Of_Token) is the empty string
         elsif (S(Start_Of_Token) = '(') or (S(Start_Of_Token) = ')') then
            End_OF_Token := Start_Of_Token; -- the bracket is the token
         elsif S(Start_Of_Token) = '"' then -- " -- begin quoted string
            End_Of_Token := Start_Of_Token + 1;
            while S(End_Of_Token) /= '"' loop -- " -- search for closing bracket
               End_Of_Token := End_Of_Token + 1;
            end loop; -- raises Constraint_Error if closing bracket not found
         else -- Token is some kind of string
            End_Of_Token := Start_Of_Token;
            while End_Of_Token < S'Last and then
           ((S(End_Of_Token+1) /= ' ') and (S(End_Of_Token+1) /= '(') and
              (S(End_Of_Token+1) /= ')') and (S(End_Of_Token+1) /= '"')) loop  -- "
               End_Of_Token := End_Of_Token + 1;
            end loop;
         end if;
      end First_Token;

      procedure To_Int(Token: String; I: out Integer; Found: out Boolean) is
         Last: Positive;
      begin
         Ada.Integer_Text_IO.Get(Token, I, Last);
         Found := Last = Token'Last;
      exception
         when others => Found := False;
      end To_Int;

      procedure To_Flt(Token: String; F: out Float; Found: out Boolean) is
         Last: Positive;
      begin
         Ada.Float_Text_IO.Get(Token, F, Last);
         Found := Last = Token'Last;
      exception
         when others => Found := False;
      end To_Flt;

      function Quoted_String(Token: String) return Boolean is
      begin
         return
           Token'Length >= 2 and then Token(Token'First)='"' -- "
                             and then Token(Token'Last) ='"'; -- "
      end Quoted_String;

      Start, Stop: Positive;

      procedure Recursive_Parse(This: in out List_Of_Data) is

      Found: Boolean;

      Flt: Flt_Data;
      Int: Int_Data;
      Str: Str_Data;
      Lst: List_Of_Data;

      begin
         while Input(Start .. Stop) /= "" loop
            if Input(Start .. Stop) = ")" then
               return;
            elsif Input(Start .. Stop) = "(" then
               First_Token(Input(Stop+1 .. Input'Last), Start, Stop);
               Recursive_Parse(Lst);
               This.Values.Append(Lst);
            else
               To_Int(Input(Start .. Stop), Int.Value, Found);
               if Found then
                  This.Values.Append(Int);
               else
                  To_Flt(Input(Start .. Stop), Flt.Value, Found);
                  if Found then
                     This.Values.Append(Flt);
                  else
                     if Quoted_String(Input(Start .. Stop)) then
                        Str.Value  := -Input(Start+1 .. Stop-1);
                        Str.Quoted := True;
                     else
                        Str.Value  := -Input(Start .. Stop);
                        Str.Quoted := False;
                     end if;
                     This.Values.Append(Str);
                  end if;
               end if;
            end if;
            First_Token(Input(Stop+1 .. Input'Last), Start, Stop);
         end loop;
      end Recursive_Parse;

      L: List_Of_Data;

   begin
      First_Token(Input, Start, Stop);
      Recursive_Parse(L);
      return L;
   end Parse;

end S_Expr.Parser;
