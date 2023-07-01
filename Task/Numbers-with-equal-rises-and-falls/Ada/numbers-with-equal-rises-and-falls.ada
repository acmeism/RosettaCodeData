with Ada.Text_Io;
with Ada.Integer_Text_Io;

procedure Equal_Rise_Fall is
   use Ada.Text_Io;

   function Has_Equal_Rise_Fall (Value : Natural) return Boolean is
      Rises : Natural := 0;
      Falls : Natural := 0;
      Image : constant String := Natural'Image (Value);
      Last  : Character := Image (Image'First + 1);
   begin
      for Pos in Image'First + 2 .. Image'Last loop
         if Image (Pos) > Last then
            Rises := Rises + 1;
         elsif Image (Pos) < Last then
            Falls := Falls + 1;
         end if;
         Last := Image (Pos);
      end loop;
      return Rises = Falls;
   end Has_Equal_Rise_Fall;

   Value : Natural := 1;
   Count : Natural := 0;
begin
   loop
      if Has_Equal_Rise_Fall (Value) then
         Count := Count + 1;
         if Count <= 200 then
            Ada.Integer_Text_Io.Put (Value, Width => 5);
            if Count mod 20 = 0 then
               New_Line;
            end if;
         end if;
         if Count = 10_000_000 then
            New_Line;
            Put_Line ("The 10_000_000th: " & Natural'Image (Value));
            exit;
         end if;
      end if;
      Value := Value + 1;
   end loop;
end Equal_Rise_Fall;
