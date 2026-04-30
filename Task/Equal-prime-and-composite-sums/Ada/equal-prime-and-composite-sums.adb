-- Rosetta Code Task written in Ada
-- Equal prime and composite sums
-- https://rosettacode.org/wiki/Equal_prime_and_composite_sums
-- August 2024, R. B. E.
-- Translated from the Lua solution (mostly)
-- Using GNAT Big Integers, GNAT version 14.1, MacOS 14.6.1, M1 chip

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Equal_Prime_and_Composite_Sums is

  function Is_Prime (N : in Big_Integer) return Boolean is
    Big_0 : Big_Natural := To_Big_Integer (0);
    Big_2 : Big_Natural := To_Big_Integer (2);
    Big_3 : Big_Natural := To_Big_Integer (3);
    Big_Temp : Big_Natural := To_Big_Integer (5);
  begin
    if N < Big_2 then
      return False;
    end if;
    if N mod Big_2 = Big_0 then
      return N = Big_2;
    end if;
    if N mod Big_3 = Big_0 then
      return N = Big_3;
    end if;
    while Big_Temp * Big_Temp <= N loop
      if N mod Big_Temp = Big_0 then
        return False;
      end if;
      Big_Temp := Big_Temp + Big_2;
      if N mod Big_Temp = Big_0 then
        return False;
      end if;
      Big_Temp := Big_Temp + 4;
    end loop;
    return True;
  end Is_Prime;

  Limit : constant Natural := 8;
  Count : Natural := 0;
  N : Big_Integer := 2;
  M : Big_Integer := 1;
  sumP : Big_Integer := 5;
  sumC : Big_Integer := 4;
  numP : Big_Integer := 3;
  numC : Big_Integer := 4;

begin
  Put_Line (( "           sum    primes composites" ));
  OUTER: loop
    if (sumC > sumP) then
      LOOP2: loop
        numP := numP + To_Big_Integer (2);
        exit LOOP2 when Is_Prime (numP);
      end loop LOOP2;
      sumP := sumP + numP;
      N := N + To_Big_Integer (1);
    end if;
    if (sumP > sumC) then
      LOOP3: loop
        numC := numC + To_Big_Integer (1);
        exit LOOP3 when not Is_Prime (numC);
      end loop LOOP3;
      sumC := sumC + numC;
      M := M + To_Big_Integer (1);
    end if;
    if (sumP = sumC) then
      Put (To_String (Arg => sumP, Width => 14));
      Put (To_String (Arg => N, Width => 10));
      Put (To_String (Arg => M, Width => 11));
      New_Line;
      Count := Count + 1;
      if Count < Limit then
        LOOP4: loop
          numC := numC + To_Big_Integer (1);
          exit LOOP4 when not Is_Prime (numC);
        end loop LOOP4;
        sumC := sumC + numC;
        M := M + To_Big_Integer (1);
      end if;
    end if;
    exit OUTER when Count >= Limit;
  end loop OUTER;
end Equal_Prime_and_Composite_Sums;
