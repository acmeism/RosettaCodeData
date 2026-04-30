-- Rosetta Code Task written in Ada
-- Eban numbers
-- https://rosettacode.org/wiki/Eban_numbers
-- Inspired (mostly) by the Nim and Go solutions
-- August 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Eban_Numbers is

  function Is_Eban (Candidate : Natural) return Boolean is
    N : Natural := Candidate;
    B, R, M, T : Natural;
  begin
    if (N = 0) then
      return False;
    end if;
    B := N / 1_000_000_000;
    R := N mod 1_000_000_000;
    M := R / 1_000_000;
    R := R mod 1_000_000;
    T := R / 1_000;
    R := R mod 1_000;

    case M is
      when 30..66 => M := M mod 10;
      when others => null;
    end case;

    case T is
      when 30..66 => T := T mod 10;
      when others => null;
    end case;

    case R is
      when 30..66 => R := R mod 10;
      when others => null;
    end case;

    if ((B = 0) or (B = 2) or (B = 4) or (B = 6)) then
      if ((M = 0) or (M = 2) or (M = 4) or (M = 6)) then
        if ((T = 0) or (T = 2) or (T = 4) or (T = 6)) then
          if ((R = 0) or (R = 2) or (R = 4) or (R = 6)) then
            return True;
          else
            return False;
          end if;
        else
          return False;
        end if;
      else
        return False;
      end if;
    else
      return False;
    end if;
  end Is_Eban;

  Group_Total : Natural;
  Loop_Starts_At, Loop_Stops_At : Natural;

begin
  Loop_Starts_At := 0;
  Loop_Stops_At := 1_000;
  Put ("eban numbers up to and including: ");
  Put (Loop_Stops_At, 3);
  New_Line;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Put (I, 0);
      Put ("  ");
    end if;
  end loop;
  New_Line (2);

  Loop_Starts_At := 1_000;
  Loop_Stops_At := 4_000;
  Put ("eban numbers between ");
  Put (Loop_Starts_At, 3);
  Put (" and ");
  Put (Loop_Stops_At, 3);
  Put_Line (" (inclusive):");
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Put (I, 0);
      Put ("  ");
    end if;
  end loop;
  New_Line (2);

  Group_Total := 0;
  Loop_Starts_At := 0;
  Loop_Stops_At := 10_000;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Group_Total := Group_Total + 1;
    end if;
  end loop;
  Put ("Number of eban numbers up to and including ");
  Put (Loop_Stops_At, 3);
  Put (": ");
  Put (Group_Total, 4);
  New_Line (2);

  Group_Total := 0;
  Loop_Starts_At := 0;
  Loop_Stops_At := 100_000;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Group_Total := Group_Total + 1;
    end if;
  end loop;
  Put ("Number of eban numbers up to and including ");
  Put (Loop_Stops_At, 3);
  Put (": ");
  Put (Group_Total, 4);
  New_Line (2);

  Group_Total := 0;
  Loop_Starts_At := 0;
  Loop_Stops_At := 1_000_000;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Group_Total := Group_Total + 1;
    end if;
  end loop;
  Put ("Number of eban numbers up to and including ");
  Put (Loop_Stops_At, 3);
  Put (": ");
  Put (Group_Total, 4);
  New_Line (2);

  Group_Total := 0;
  Loop_Starts_At := 0;
  Loop_Stops_At := 10_000_000;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Group_Total := Group_Total + 1;
    end if;
  end loop;
  Put ("Number of eban numbers up to and including ");
  Put (Loop_Stops_At, 3);
  Put (": ");
  Put (Group_Total, 4);
  New_Line (2);

  Group_Total := 0;
  Loop_Starts_At := 0;
  Loop_Stops_At := 100_000_000;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Group_Total := Group_Total + 1;
    end if;
  end loop;
  Put ("Number of eban numbers up to and including ");
  Put (Loop_Stops_At, 3);
  Put (": ");
  Put (Group_Total, 4);
  New_Line (2);

  Group_Total := 0;
  Loop_Starts_At := 0;
  Loop_Stops_At := 1_000_000_000;
  for I in Loop_Starts_At .. Loop_Stops_At loop
    if Is_Eban (I) then
      Group_Total := Group_Total + 1;
    end if;
  end loop;
  Put ("Number of eban numbers up to and including ");
  Put (Loop_Stops_At, 3);
  Put (": ");
  Put (Group_Total, 4);
  New_Line (2);
end Eban_Numbers;
