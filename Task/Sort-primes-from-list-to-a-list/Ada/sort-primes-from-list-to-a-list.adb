-- Rosetta Code Task written in Ada
-- Sort primes from list to a list
-- https://rosettacode.org/wiki/Sort_primes_from_list_to_a_list
-- Sort procedure taken from Ada task: "Sorting algorithms/Insertion sort"
-- November 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Extract_and_Sort_Primes is

  type Data_Array is array(Natural range <>) of Integer;

  procedure Insertion_Sort(Item : in out Data_Array) is
    First : Natural := Item'First;
    Last  : Natural := Item'Last;
    Value : Integer;
    J     : Integer;
  begin
    for I in (First + 1)..Last loop
      Value := Item(I);
      J := I - 1;
      while J in Item'range and then Item(J) > Value loop
        Item(J + 1) := Item(J);
        J := J - 1;
      end loop;
      Item(J + 1) := Value;
    end loop;
  end Insertion_Sort;

  function Is_Prime (P : Positive) return Boolean is
    D : Positive := 5;
  begin
    if (P < 2) then
      return False;
    end if;
    if ((P mod 2) = 0) then
      return (P = 2);
    end if;
    if ((P mod 3) = 0) then
      return (P = 3);
    end if;
    while ((D * D) <= P) loop
      if ((P mod D) = 0) then
        return False;
      end if;
      D := D + 2;
    end loop;
    return True;
  end Is_Prime;

  Data : Data_Array := (2, 43, 81, 122, 63, 13, 7, 95, 103);

begin
  New_Line;
  Put_Line ("Task: Sort primes from list to a list");
  New_Line;
  Put_Line ("Data (as provided by task description) prior to sorting:");
  for Number of Data loop
    Put (Number, 4);
  end loop;
  New_Line (2);
  Insertion_Sort (Data);
  Put_Line ("Provided data after sorting:");
  for Number of Data loop
    Put (Number, 4);
  end loop;
  New_Line (2);
  Put_Line ("Prime numbers extracted from the provided data:");
  for Number of Data loop
    if Number > 0 and then Is_Prime (Number) then
      Put (Number, 4);
    end if;
  end loop;
  New_Line;
end Extract_and_Sort_Primes;
