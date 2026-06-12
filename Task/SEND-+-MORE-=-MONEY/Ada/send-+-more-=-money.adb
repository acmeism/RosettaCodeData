-- Rosetta Code Task written in Ada
-- SEND + MORE = MONEY
-- https://rosettacode.org/wiki/SEND_%2B_MORE_%3D_MONEY
-- loosely translated the Nim solution
-- I'm very sure that there exists at least one vastly superior solution for this task written in Ada.
-- May 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Send_More_Money is

  function Distinct (M, S, E, N, D, O, R, Y : Natural) return Boolean is
  begin
    if (M = S) then return False; end if;
    if (M = E) then return False; end if;
    if (M = N) then return False; end if;
    if (M = D) then return False; end if;
    if (M = O) then return False; end if;
    if (M = R) then return False; end if;
    if (M = Y) then return False; end if;
    if (S = E) then return False; end if;
    if (S = N) then return False; end if;
    if (S = D) then return False; end if;
    if (S = O) then return False; end if;
    if (S = R) then return False; end if;
    if (S = Y) then return False; end if;
    if (E = N) then return False; end if;
    if (E = D) then return False; end if;
    if (E = O) then return False; end if;
    if (E = R) then return False; end if;
    if (E = Y) then return False; end if;
    if (N = D) then return False; end if;
    if (N = O) then return False; end if;
    if (N = R) then return False; end if;
    if (N = Y) then return False; end if;
    if (D = O) then return False; end if;
    if (D = R) then return False; end if;
    if (D = Y) then return False; end if;
    if (O = R) then return False; end if;
    if (O = Y) then return False; end if;
    if (R = Y) then return False; end if;
    return True;
  end Distinct;

  function Calculate (M, S, E, N, D, O, R, Y : Natural) return Boolean is
    SEND  : Natural := (1000 * S + 100 * E + 10 * N + D);
    MORE  : Natural := (1000 * M + 100 * O + 10 * R + E);
    MONEY : Natural := (10000 * M + 1000 * O + 100 * N + 10 * E + Y);
  begin
    return ((SEND + MORE) = MONEY);
  end Calculate;

  procedure Display (M, S, E, N, D, O, R, Y : Natural) is
  begin
    Put_Line ("The problem:");
    Put_Line ("   SEND");
    Put_Line ("+  MORE");
    Put_Line ("-------");
    Put_Line ("= MONEY");
    New_Line;
    Put_Line ("The solution:");
    Put ("   "); Put (S, 0); Put (E, 0); Put (N, 0); Put (D, 0);
    New_Line;
    Put ("+  ");
    Put (M, 0); Put (O, 0); Put (R, 0); Put (E, 0);
    New_Line;
    Put_Line ("-------");
    Put ("= ");
    Put (M, 0); Put (O, 0); Put (N, 0); Put (E, 0); Put (Y, 0);
    New_Line;
  end Display;

  M : Natural := 1;

begin
  for S in 8..9 loop
    for E in 0..9 loop
      for N in 0..9 loop
        for D in 0..9 loop
          for O in 0..9 loop
            for R in 0..9 loop
              for Y in 0..9 loop
                if (Distinct (M, S, E, N, D, O, R, Y)) and (Calculate (M, S, E, N, D, O, R, Y)) then
                  Display (M, S, E, N, D, O, R, Y);
                end if;
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
  end loop;
end Send_More_Money;
