-- Rosetta Code Task written in Ada
-- Find squares n where n+1 is prime
-- https://rosettacode.org/wiki/Find_squares_n_where_n%2B1_is_prime
-- Loosely translated from the AWK solution
-- September 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure N_Squared_Where_N_Plus_One_Is_Prime is

  function Is_Prime (N : in Natural) return Boolean is
    Temp : Natural := 5;
  begin
    if N < 2 then
      return False;
    end if;
    if N mod 2 = 0 then
      return N = 2;
    end if;
    if N mod 3 = 00 then
      return N = 3;
    end if;
    while Temp * Temp <= N loop
      if N mod Temp = 0 then
        return False;
      end if;
      Temp := Temp + 2;
      if N mod Temp = 0 then
        return False;
      end if;
      Temp := Temp + 4;
    end loop;
    return True;
  end Is_Prime;

  procedure Display (Start, Stop, Count : Positive) is
  begin
    New_Line;
    Put ("Find squares: ");
    Put (Start, 0);
    Put ("-");
    Put (Stop, 0);
    Put (": ");
    Put (Count, 3);
    New_Line;
  end Display;

  Count : Natural := 0;
  Start : Positive := 1;
  Stop  : Positive := 999;
  N : Positive := 2;
  N2 : Positive := N ** 2;
begin
  Put (1, 4);
  Count := Count + 1;
  while (N2 < Stop) loop
    if (Is_Prime (N2 + 1)) then
      Put (N2, 4);
      Count := Count + 1;
    end if;
    N := N + 2;
    N2 := N ** 2;
  end loop;
  Display (Start, Stop, Count);
end N_Squared_Where_N_Plus_One_Is_Prime;
