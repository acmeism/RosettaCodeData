-- Rosetta Code Task written in Ada
-- Giuga numbers
-- https://rosettacode.org/wiki/Giuga_numbers
-- Translated from the Nim solution
-- July 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

procedure Giuga_Numbers is

  function Is_Giuga (M : Natural) return Boolean is
    N : Natural := M;
    F : Natural := 2;
    L : Integer := Integer (sqrt (Float (N)));
  begin
    loop
      if ((N mod F) = 0) then
        if ((((M / F) - 1) mod F) /= 0) then
          return False;
        end if;
        N := N / F;
        if (F > N) then
          return True;
        end if;
        else
          F := F + 1;
          if (F > L) then
            return False;
          end if;
      end if;
    end loop;
  end Is_Giuga;

  C : Natural := 0;
  N : Natural := 3;
  Limit : constant Integer := 4;

begin
  Put ("The first ");
  Put (Limit, 1);
  Put (" Giuga numbers are: ");
  loop
    if (Is_Giuga (N)) then
      C := C + 1;
      Put (N, 1);
      Put (" ");
    end if;
    N := N + 1;
    exit when C = Limit;
  end loop;
  New_Line;
end Giuga_Numbers;
