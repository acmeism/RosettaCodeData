with Ada.Text_IO;
with Mode;
procedure Main is
   type Int_Array is array (Positive range <>) of Integer;
   package Int_Mode is new Mode (Integer, Int_Array);

   Test_1 : Int_Array := (1, 2, 3, 1, 2, 4, 2, 5, 2, 3, 3, 1, 3, 6);
   Result : Int_Array := Int_Mode.Get_Mode (Test_1);
begin
   Ada.Text_IO.Put ("Input: ");
   for I in Test_1'Range loop
      Ada.Text_IO.Put (Integer'Image (Test_1 (I)));
      if I /= Test_1'Last then
         Ada.Text_IO.Put (",");
      end if;
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put ("Result:");
   for I in Result'Range loop
      Ada.Text_IO.Put (Integer'Image (Result (I)));
      if I /= Result'Last then
         Ada.Text_IO.Put (",");
      end if;
   end loop;
   Ada.Text_IO.New_Line;
end Main;
