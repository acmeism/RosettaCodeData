with Ada.Text_IO, Interfaces;
use  Ada.Text_IO, Interfaces;

procedure Bitwise is
   subtype Byte is Unsigned_8;
   package Byte_IO is new Ada.Text_Io.Modular_IO (Byte);

   A : constant Byte    := 2#00011110#;
   B : constant Byte    := 2#11110100#;
   X : constant Byte    := 128;
   N : constant Natural := 1;
begin
   Put ("A and B = ");  Byte_IO.Put (Item => A and B, Base => 2);  New_Line;
   Put ("A or B  = ");  Byte_IO.Put (Item => A or B,  Base => 2);  New_Line;
   Put ("A xor B = ");  Byte_IO.Put (Item => A xor B, Base => 2);  New_Line;
   Put ("not A   = ");  Byte_IO.Put (Item => not A,   Base => 2);  New_Line;
   New_Line (2);
   Put_Line (Unsigned_8'Image (Shift_Left  (X, N)));
   Put_Line (Unsigned_8'Image (Shift_Right (X, N)));
   Put_Line (Unsigned_8'Image (Shift_Right_Arithmetic (X, N)));
   Put_Line (Unsigned_8'Image (Rotate_Left  (X, N)));
   Put_Line (Unsigned_8'Image (Rotate_Right (X, N)));
end Bitwise;
