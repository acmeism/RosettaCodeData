with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Long_Integer_Text_IO,
  Ada.Long_Long_Integer_Text_IO, Ada.Float_Text_IO, Ada.Long_Float_Text_IO,
  Ada.Long_Long_Float_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Long_Integer_Text_IO,
  Ada.Long_Long_Integer_Text_IO, Ada.Float_Text_IO, Ada.Long_Float_Text_IO,
  Ada.Long_Long_Float_Text_IO;

procedure Test5 is

   I    : Integer           := 0;
   LI   : Long_Integer      := 0;
   LLI  : Long_Long_Integer := 0;
   F    : Float             := 0.0;
   LF   : Long_Float        := 0.0;
   LLF  : Long_Long_Float   := 0.0;
   Zero : Natural           := 0;

begin
   Put ("Integer           0^0 = ");
   Put (I ** Zero, 2);   New_Line;
   Put ("Long Integer      0^0 = ");
   Put (LI ** Zero, 2);  New_Line;
   Put ("Long Long Integer 0^0 = ");
   Put (LLI ** Zero, 2); New_Line;
   Put ("Float           0.0^0 = ");
   Put (F ** Zero);   New_Line;
   Put ("Long Float      0.0^0 = ");
   Put (LF ** Zero);  New_Line;
   Put ("Long Long Float 0.0^0 = ");
   Put (LLF ** Zero); New_Line;
end Test5;
