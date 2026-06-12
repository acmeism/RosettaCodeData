with Ada.Text_Io;        use Ada.Text_Io;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;

procedure Two_Identical is
   package Integer_Io is
     new Ada.Text_Io.Integer_Io (Integer);
   use Integer_Io;

   Image : String (1 .. 16);
   Pos_1, Pos_2 : Natural;
   Mid  : Natural;
begin
   for N in 1 .. 1000 loop
      Put (Image, N, Base => 2);
      Pos_1 := Index (Image, "#");
      Pos_2 := Index (Image, "#", Pos_1 + 1);
      Mid := (Pos_1 + Pos_2) / 2;
      if Image (Pos_1 + 1 .. Mid) = Image (Mid + 1 .. Pos_2 - 1) then
         Put (N, Width => 3); Put ("  "); Put (Image); New_Line;
      end if;
   end loop;
end Two_Identical;
