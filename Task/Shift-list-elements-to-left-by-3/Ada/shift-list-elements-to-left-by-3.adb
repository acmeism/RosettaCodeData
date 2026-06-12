with Ada.Text_Io;

procedure Shift_Left is

   Shift_Count : constant := 3;

   type List_Type is array (Positive range <>) of Integer;

   procedure Put_List (List : List_Type) is
      use Ada.Text_Io;
   begin
      for V of List loop
         Put (V'Image); Put ("  ");
      end loop;
      New_Line;
   end Put_List;

   Shift : List_Type := (1, 2, 3, 4, 5, 6, 7, 8, 9);
begin
   Put_List (Shift);

   Shift :=
     Shift (Shift'First + Shift_Count .. Shift'Last) &
       Shift (Shift'First .. Shift_Count);

   Put_List (Shift);
end Shift_Left;
