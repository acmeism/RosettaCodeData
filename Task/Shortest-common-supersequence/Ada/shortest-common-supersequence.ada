with Ada.Text_IO;

procedure Shortest is

   function Scs (Left, Right : in String) return String is
      Left_Tail  : String renames Left  (Left'First  + 1 .. Left'Last);
      Right_Tail : String renames Right (Right'First + 1 .. Right'Last);
   begin
      if Left  = "" then return Right; end if;
      if Right = "" then return Left;  end if;

      if Left (Left'First) = Right (Right'First) then
         return Left (Left'First) & Scs (Left_Tail, Right_Tail);
      end if;

      declare
         S1 : constant String := Scs (Left, Right_Tail);
         S2 : constant String := Scs (Left_Tail, Right);
      begin
         return (if S1'Length <= S2'Length
                 then Right (Right'First) & S1
                 else Left  (Left'First)  & S2);
      end;
   end Scs;

   procedure Exercise (Left, Right : String) is
      use Ada.Text_Io;
   begin
      Put ("scs ( "); Put (Left); Put (" , "); Put (Right); Put ( " ) -> ");
      Put (Scs (Left, Right));
      New_Line;
   end Exercise;

begin
   Exercise ("abcbdab", "bdcaba");
   Exercise ("WEASELS", "WARDANCE");
end Shortest;
