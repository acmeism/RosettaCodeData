-- Rosetta Code Task written in Ada
-- Odd and square numbers
-- https://rosettacode.org/wiki/Odd_and_square_numbers
-- March 2025, R. B. E.

with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Odd_and_Square is
  I : Positive := 3;
  I_Squared : Positive;
begin
  loop
    I_Squared := I * I;
    exit when I_Squared > 1000;
    if (I_Squared > 99) then
      Ada.Integer_Text_IO.Put (I_Squared, 4);
    end if;
    I := I + 2;
  end loop;
  Ada.Text_IO.New_Line;
end Odd_and_Square;
