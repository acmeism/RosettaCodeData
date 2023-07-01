with Ada.Long_Complex_Text_IO; use Ada.Long_Complex_Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Long_Complex_Types; use Ada.Numerics.Long_Complex_Types;
with Ada.Numerics.Long_Complex_Elementary_Functions; use Ada.Numerics.Long_Complex_Elementary_Functions;
procedure Eulers_Identity is
begin
   Put (Exp (Pi * i) + 1.0);
end Eulers_Identity;
