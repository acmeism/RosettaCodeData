-- Rosetta Code Task written in Ada
-- Task name: "Jacobsthal numbers"
-- Task URL: https://rosettacode.org/wiki/Jacobsthal_numbers
-- I increased the the number of generated Jacobsthal Numbers and
-- Jacobsthal-Lucas Numbers to 35 from the task specified 30.
-- four command line parameters are required: 35 (J_N), 35 (J_L), 20 (J_Oblong), 10 (J_Prime_Limit)
-- September 2024, R. B. E.

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Command_Line; use Ada.Command_Line;

procedure Jacobsthal_Numbers is

  function Is_Prime (N : in Natural) return Boolean is
    Temp : Natural := 5;
  begin
    if N < 2 then
      return False;
    end if;
    if N mod 2 = 0 then
      return N = 2;
    end if;
    if N mod 3 = 0 then
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

  J_N_Limit : constant Positive := Positive'Value (Argument (1)); -- should be 35 (could be more)
  J_L_Limit : constant Positive := Positive'Value (Argument (2)); -- should be 35 (could be more)
  J_O_Limit : constant Positive := Positive'Value (Argument (3)); -- should be 20 (could be more)
  J_Prime_Limit : constant Positive := Positive'Value (Argument (4)); -- should be exactly 10
  type Array_Containing_Big_Naturals is array (natural range <>) of Big_Natural;
  J_N : Array_Containing_Big_Naturals (0..J_N_Limit);
  J_L : Array_Containing_Big_Naturals (0..J_L_Limit);
  J_Oblong : Array_Containing_Big_Naturals (0..J_O_Limit);
  Big_0 : Big_Natural := To_Big_Integer (0);
  Big_1 : Big_Natural := To_Big_Integer (1);
  Big_2 : Big_Natural := To_Big_Integer (2);
  J_Prime_Count : Natural;

begin
   if Argument_Count /= 4 then
      Put_Line ("Usage: ./jacobsthal_numbers 35 35 20 10");
      return;
   end if;

  -- This section is for the Jacobsthal Numbers (generating, preserving, displaying)
  J_N (0) := Big_0;
  J_N (1) := Big_1;
  for I in 2..J_N_Limit loop
    J_N (I) := J_N (I-1) + (Big_2 * J_N (I-2));
  end loop;
  New_Line;
  Put ("The first ");
  Put (J_N_Limit, 0);
  Put_Line (" Jacobsthal numbers:");
  for I in 0..J_N_Limit loop
    Put (To_String (J_N (I)));
  end loop;
  New_Line;

  -- This section is for the Jacobsthal-Lucas Numbers (generating, preserving, displaying)
  J_L (0) := Big_2;
  J_L (1) := Big_1;
  for I in 2..J_L_Limit loop
    J_L (I) := J_L (I-1) + (Big_2 * J_L (I-2));
  end loop;
  New_Line;
  Put ("The first ");
  Put (J_L_Limit, 0);
  Put_Line (" Jacobsthal_Lucas numbers:");
  for I in 0..J_L_Limit loop
    Put (To_String (J_L (I)));
  end loop;
  New_Line;

  -- This section is for the Jacobsthal-Oblong Numbers (generating, preserving, displaying)
  for I in 0..J_O_Limit loop
    J_Oblong (I) := J_N (I) * J_N (I+1);
  end loop;
  New_Line;
  Put ("The first ");
  Put (J_O_Limit, 0);
  Put_Line (" Jacobsthal-Oblong numbers:");
  for I in 0..J_O_Limit loop
    Put (To_String (J_Oblong (I)));
  end loop;
  New_Line;

  -- This section is for the display of Jacobsthal prime numbers
  New_Line;
  Put ("The first ");
  Put (J_Prime_Limit, 0);
  Put_Line (" Jacobsthal prime numbers are:");
  J_Prime_Count := 0;
  -- danger here: Not all items in the J_N array can successfully be converted from Big_Integer to Integer...
  for I in 3..J_N'Last loop
    if Is_Prime (To_Integer ((J_N (I)))) then
      J_Prime_Count := J_Prime_Count + 1;
      Put (To_String (J_N (I)));
      New_Line;
    end if;
    exit when J_Prime_Count >= J_Prime_Limit;
  end loop;
  New_Line;

end Jacobsthal_Numbers;
