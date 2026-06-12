-- Rosetta Code Task written in Ada
-- Double Twin Primes
-- https://rosettacode.org/wiki/Double_Twin_Primes
-- Loosely translated from the Nim solution
-- December 2024, R. B. E.

with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Double_Twin_Primes is
  Sieve_Size : constant Positive := 1000;
  type Sieve_Array is array (2..Sieve_Size) of Boolean;
  Sieve : Sieve_Array := (others => False);

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

begin
  -- Generate the Sieve
  for I in 2..Sieve_Size loop
    if Is_Prime (I) then
      Sieve (I) := True;
    end if;
  end loop;
  -- Search and Display Double Twin Primes
  for I in 3..(Sieve_Size - 8) loop
    if (I mod 2 /= 0) and Sieve (I) and Sieve (I+2) and Sieve (I+6) and Sieve (I+8) then
      Ada.Text_IO.Put ("(");
      Ada.Integer_Text_IO.Put (I, 4);
      Ada.Integer_Text_IO.Put (I+2, 4);
      Ada.Integer_Text_IO.Put (I+6, 4);
      Ada.Integer_Text_IO.Put (I+8, 4);
      Ada.Text_IO.Put (")");
      Ada.Text_IO.New_Line;
    end if;
  end loop;
end Double_Twin_Primes;
