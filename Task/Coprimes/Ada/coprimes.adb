-- Rosetta Code Task written in Ada
-- Coprimes
-- https://rosettacode.org/wiki/Coprimes
-- used the Gcd function (as is) from https://rosettacode.org/wiki/Greatest_common_divisor#Ada
-- Took advantage of the Wren task comment: "Two numbers are coprime if their GCD is 1."
-- May 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;

procedure Coprimes is

  function Gcd (A, B : Integer) return Integer is
    M : Integer := A;
    N : Integer := B;
    T : Integer;
  begin
    while N /= 0 loop
      T := M;
      M := N;
      N := T mod N;
    end loop;
    return M;
  end Gcd;

  function Is_Coprime (X, Y : Integer) return Boolean is
  begin
    if (Gcd (X, Y) = 1) then
      return True;
    else
      return False;
    end if;
  end Is_Coprime;

begin
  Put_Line ("Are 21 and 15 coprime? " & Boolean'Image (Is_Coprime (21, 15)));
  Put_Line ("Are 17 and 23 coprime? " & Boolean'Image (Is_Coprime (17, 23)));
  Put_Line ("Are 36 and 12 coprime? " & Boolean'Image (Is_Coprime (36, 12)));
  Put_Line ("Are 18 and 29 coprime? " & Boolean'Image (Is_Coprime (18, 29)));
  Put_Line ("Are 60 and 15 coprime? " & Boolean'Image (Is_Coprime (60, 15)));
end Coprimes;

