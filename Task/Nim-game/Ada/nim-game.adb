with Ada.Text_IO;

procedure Nim is
   subtype Token_Range is Positive range 1 .. 3;

   package TIO renames Ada.Text_IO;
   package Token_IO is new TIO.Integer_IO(Token_Range);

   procedure Get_Tokens(remaining : in Natural; how_many : out Token_Range) is
   begin
      loop
         TIO.Put("How many tokens would you like to take? ");
         begin
            Token_IO.Get(TIO.Standard_Input, how_many);
            exit when how_many < remaining;
            raise Constraint_Error;
         exception
            when TIO.Data_Error | Constraint_Error =>
               if not TIO.End_Of_Line(TIO.Standard_Input) then
                  TIO.Skip_Line(TIO.Standard_Input);
               end if;
               TIO.Put_Line("Invalid input.");
         end;
      end loop;
   end;

    tokens : Natural := 12;
    how_many : Token_Range;
begin
   loop
      TIO.Put_Line(tokens'Img & " tokens remain.");
      -- no exit condition here: human cannot win.
      Get_Tokens(tokens, how_many);
      TIO.Put_Line("Human takes" & how_many'Img & " tokens.");
      tokens := tokens - how_many;
      -- computer's turn: take the remaining N tokens to amount to 4.
      how_many := tokens mod 4;
      TIO.Put_Line("Computer takes" & how_many'Img & " tokens.");
      tokens := tokens - how_many;
      Ada.Text_IO.New_Line;
      exit when tokens = 0;
   end loop;

   TIO.Put_Line("Computer won!");
end Nim;
