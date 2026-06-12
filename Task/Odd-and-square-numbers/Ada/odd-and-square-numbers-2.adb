-- Rosetta Code Task written in Ada
-- Odd and square numbers
-- https://rosettacode.org/wiki/Odd_and_square_numbers
-- March 2025, R. B. E.

with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Odd_and_Square is
  I_Squared : Positive;
  Start_Squaring : constant Positive := 11;
  Stop_Squaring : constant Positive := 31;
begin
  for I in Start_Squaring..Stop_Squaring loop
    if ((I mod 2) /= 0) then
      I_Squared := I * I;
      Ada.Integer_Text_IO.Put (I_Squared, 4);
    end if;
  end loop;
  Ada.Text_IO.New_Line;
end Odd_and_Square;
