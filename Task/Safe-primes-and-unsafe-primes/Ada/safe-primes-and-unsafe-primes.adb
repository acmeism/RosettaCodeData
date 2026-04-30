-- Rosetta Code Task written in Ada
-- Safe primes and unsafe primes
-- https://rosettacode.org/wiki/Safe_primes_and_unsafe_primes
-- Inspired by all of the solutions
-- August 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Safe_Primes_and_Unsafe_Primes is

  function Is_Prime (N : Natural) return Boolean is
    Temp : Positive := 5;
  begin
    if N < 2 then
      return False;
    end if;
    if (N mod 2) = 0 then
      return N = 2;
    end if;
    if (N mod 3) = 0 then
      return N = 3;
    end if;
    while Temp * Temp <= N loop
      if (N mod Temp) = 0 then
        return False;
      end if;
      Temp := Temp + 2;
      if (N mod Temp) = 0 then
        return False;
      end if;
      Temp := Temp + 4;
    end loop;
    return True;
  end Is_Prime;

  procedure Generate_Safe_Primes (Max_Prime : Positive := 35) is
    Candidate, Temp, Safe_Prime_Count : Natural;
  begin
    Safe_Prime_Count := 0;
    Candidate := 2;
    if (Max_Prime = 35) then
      Put ("The first ");
      Put (Max_Prime, 1);
      Put (" Safe Primes are: ");
      Candidate := 2;
      loop
        Temp := (Candidate - 1) / 2;
        if (is_Prime (Candidate)) and then Is_Prime (Temp) then
          Safe_Prime_Count := Safe_Prime_Count + 1;
          Put (Candidate, 1);
          if (Safe_Prime_Count < Max_Prime) then
            Put (", ");
          end if;
        end if;
        Candidate := Candidate + 1;
        exit when Safe_Prime_Count >= Max_Prime;
      end loop;
    else
      loop
        Temp := (Candidate - 1) / 2;
        if (is_Prime (Candidate)) and then Is_Prime (Temp) then
          Safe_Prime_Count := Safe_Prime_Count + 1;
        end if;
        Candidate := Candidate + 1;
        exit when Candidate >= Max_Prime;
      end loop;
      Put ("The number of Safe Primes under ");
      Put (Max_Prime, 6);
      Put (" is ");
      Put (Safe_Prime_Count, 1);
    end if;
    New_Line;
  end Generate_Safe_Primes;

  procedure Generate_Unsafe_Primes (Max_Prime : Positive := 40) is
    Candidate, Temp, Unsafe_Prime_Count : Natural;
  begin
    Unsafe_Prime_Count := 0;
    Candidate := 2;
    if (Max_Prime = 40) then
      Put ("The first ");
      Put (Max_Prime, 1);
      Put (" Unsafe Primes are: ");
      loop
        Temp := (Candidate - 1) / 2;
        if (is_Prime (Candidate)) and then not Is_Prime (Temp) then
          Unsafe_Prime_Count := Unsafe_Prime_Count + 1;
          Put (Candidate, 1);
          if (Unsafe_Prime_Count < Max_Prime) then
            Put (", ");
          end if;
        end if;
        Candidate := Candidate + 1;
        exit when Unsafe_Prime_Count >= Max_Prime;
      end loop;
    else
      loop
        Temp := (Candidate - 1) / 2;
        if (is_Prime (Candidate)) and then not Is_Prime (Temp) then
          Unsafe_Prime_Count := Unsafe_Prime_Count + 1;
        end if;
        Candidate := Candidate + 1;
        exit when Candidate >= Max_Prime;
      end loop;
      Put ("The number of Unsafe Primes under ");
      Put (Max_Prime, 6);
      Put (" is ");
      Put (Unsafe_Prime_Count, 1);
    end if;
    New_Line;
  end Generate_Unsafe_Primes;

  One_Million_Candidates : Positive := 1_000_000;
  Ten_Million_Candidates : Positive := 10_000_000;

begin
  New_Line; Generate_Safe_Primes (35);
  New_Line; Generate_Safe_Primes (One_Million_Candidates);
  New_Line; Generate_Safe_Primes (Ten_Million_Candidates);
  New_Line; Generate_Unsafe_Primes (40);
  New_Line; Generate_Unsafe_Primes (One_Million_Candidates);
  New_Line; Generate_Unsafe_Primes (Ten_Million_Candidates);
  New_Line;
end Safe_Primes_and_Unsafe_Primes;
