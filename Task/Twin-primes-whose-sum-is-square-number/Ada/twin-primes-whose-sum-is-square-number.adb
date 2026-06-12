-- Rosetta Code Task written in Ada
-- Twin primes whose sum is square number
-- https://rosettacode.org/wiki/Twin_primes_whose_sum_is_square_number
-- Correction: I fixed the bug; I was not using "Twin" Primes, I was using "Adjacent" Primes :-)
-- November 2024, R. B. E.

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Twin_Primes_Whose_Sum_is_a_Square_Number is

  Max_Square : constant Positive := 5_000; -- determined based on the Max Prime Candidate
  type List_of_Squares_Array is array (2..Max_Square) of Positive;
  List_of_Squares : List_of_Squares_Array;

  procedure Load_List_of_Squares (List_of_Squares : in out List_of_Squares_Array) is
  begin
    for I in List_of_Squares'Range loop
      List_of_Squares (I) := I * I;
    end loop;
  end Load_List_of_Squares;

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
    end loop;
    return True;
  end Is_Prime;

  procedure Print_Results (J, Square, Left_Twin_Prime, Right_Twin_Prime : Positive) is
  begin
    New_Line;
    Put (J, 0);
    Put ("^2 = ");
    Put (Square, 0);
    Put (" = ");
    Put (Left_Twin_Prime, 0);
    Put (" + ");
    Put (Right_Twin_Prime, 0);
  end Print_Results;

  Left_Twin_Prime, Right_Twin_Prime, Sum : Positive;
  Max_Prime_Candidate : Positive := 10_000_000; -- per task description

begin
  Load_List_of_Squares (List_of_Squares);
  Left_Twin_Prime := 3;
  for I in 4..Max_Prime_Candidate loop
    if Is_Prime (I) then
      Right_Twin_Prime := I;
      Sum := Left_Twin_Prime + Right_Twin_Prime;
      for J in List_of_Squares'Range loop
        if Sum = List_of_Squares (J) then
          if ((Right_Twin_Prime - Left_Twin_Prime) = 2) then
            Print_Results (J, List_of_Squares (J), Left_Twin_Prime, Right_Twin_Prime);
          end if;
        end if;
        exit when Sum < List_of_Squares (J);
      end loop;
    end if;
    Left_Twin_Prime := Right_Twin_Prime;
  end loop;
end Twin_Primes_Whose_Sum_is_a_Square_Number;


