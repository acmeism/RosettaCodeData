-- Rosetta Code Task written in Ada
-- Angles (geometric), normalization and conversion
-- https://rosettacode.org/wiki/Angles_(geometric),_normalization_and_conversion
-- translation from C (conversion functions) and (loosely) Lua (output table formatting)
-- July 2024, R. B. E.

-- To Do:
-- Specific float format/precision rather than generic?

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Numerics;

procedure Angles_Geometric_Normalization_and_Conversion is
  Pi : constant := Ada.Numerics.Pi;
  Two_Pi : constant := 2.0 * Ada.Numerics.Pi;

  function Normalize_to_Deg (a : Float) return Float is
    tmp : Float := a;
  begin
--    while (tmp < 0.0) loop
    while (tmp < -360.0) loop -- task description says to preserve negative input angles
      tmp := tmp + 360.0;
    end loop;
    while (tmp >= 360.0) loop
      tmp := tmp - 360.0;
    end loop;
    return tmp;
  end Normalize_to_Deg;

  function Normalize_to_Grad (a : Float) return Float is
    tmp : Float := a;
  begin
    while (tmp < 0.0) loop -- task description says to preserve negative input angles (punting)
      tmp := tmp + 400.0;
    end loop;
    while (tmp >= 400.0) loop
      tmp := tmp - 400.0;
    end loop;
    return tmp;
  end Normalize_to_Grad;

  function Normalize_to_Mil (a : Float) return Float is
    tmp : Float := a;
  begin
    while (tmp < 0.0) loop -- task description says to preserve negative input angles (punting)
      tmp := tmp + 6400.0;
    end loop;
    while (tmp >= 6400.0) loop
      tmp := tmp - 6400.0;
    end loop;
    return tmp;
  end Normalize_to_Mil;

  function Normalize_to_Rad (a : Float) return Float is
    tmp : Float := a;
  begin
    while (tmp < 0.0) loop -- task description says to preserve negative input angles (punting)
      tmp := tmp + Two_Pi;
    end loop;
    while (tmp >= Two_Pi) loop
      tmp := tmp - Two_Pi;
    end loop;
    return tmp;
  end Normalize_to_Rad;

  function Deg_to_Grad (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (10.0 / 9.0);
    return tmp;
  end Deg_to_Grad;

  function Deg_to_Mil (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (160.0 / 9.0);
    return tmp;
  end Deg_to_Mil;

  function Deg_to_Rad (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (Pi / 180.0);
    return tmp;
  end Deg_to_Rad;

  function Grad_to_Deg (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (9.0 / 10.0);
    return tmp;
  end Grad_to_Deg;

  function Grad_to_Mil (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * 16.0;
    return tmp;
  end Grad_to_Mil;

  function Grad_to_Rad (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (Pi / 200.0);
    return tmp;
  end Grad_to_Rad;

  function Mil_to_Deg (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (9.0 / 160.0);
    return tmp;
  end Mil_to_Deg;

  function Mil_to_Grad (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a / 16.0;
    return tmp;
  end Mil_to_Grad;

  function Mil_to_Rad (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (Pi / 3200.0);
    return tmp;
  end Mil_to_Rad;

  function Rad_to_Deg (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (180.0 / Pi);
    return tmp;
  end Rad_to_Deg;

  function Rad_to_Grad (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (200.0 / Pi);
    return tmp;
  end Rad_to_Grad;

  function Rad_to_Mil (a : Float) return Float is
    tmp : Float := a;
  begin
    tmp := a * (3200.0 / Pi);
    return tmp;
  end Rad_to_Mil;

  Three_Spaces : constant String := 3 * " ";

  type Index is range 1 .. 12;
  type Test_Values_Array is array (Index) of Float;
  Test_Values : Test_Values_Array :=
    (Float (-2), Float (-1), Float (0), Float (1), Float (2),
     6.2831853, Float (16), 57.2957795, Float (359),
     Float (399), Float (6399), Float (1000000));

begin
  Put_Line ("                        DEGREES         GRADIANS         MILS          RADIANS");
  Put_Line ("      TEST VALUE      Normalized       Converted       Converted      Converted");
  for I in Index loop
    Put (Test_Values (I), Exp => 0, Aft => 8, Fore => 8);
    Put (Three_Spaces);
    Put (Normalize_to_Deg (Test_Values (I)), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Deg_to_Grad (Normalize_to_Deg (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Deg_to_Mil (Normalize_to_Deg (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Deg_to_Rad (Normalize_to_Deg (Test_Values (I))), Exp => 0, Aft => 8, Fore => 2);
    New_Line;
  end loop;

  New_Line;
  Put_Line ("                       GRADIANS           MILS        RADIANS        DEGREES");
  Put_Line ("      TEST VALUE      Normalized       Converted     Converted      Converted");
  for I in Index loop
    Put (Test_Values (I), Exp => 0, Aft => 8, Fore => 8);
    Put (Three_Spaces);
    Put (Normalize_to_Grad (Test_Values (I)), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Grad_to_Mil (Normalize_to_Grad (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Grad_to_Rad (Normalize_to_Grad (Test_Values (I))), Exp => 0, Aft => 8, Fore => 2);
    Put (Three_Spaces);
    Put (Grad_to_Deg (Normalize_to_Grad (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    New_Line;
  end loop;

  New_Line;
  Put_Line ("                         MILS           RADIANS       DEGREES        GRADIANS");
  Put_Line ("      TEST VALUE      Normalized       Converted     Converted      Converted");
  for I in Index loop
    Put (Test_Values (I), Exp => 0, Aft => 8, Fore => 8);
    Put (Three_Spaces);
    Put (Normalize_to_Mil (Test_Values (I)), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Mil_to_Rad (Normalize_to_Mil (Test_Values (I))), Exp => 0, Aft => 8, Fore => 2);
    Put (Three_Spaces);
    Put (Mil_to_Deg (Normalize_to_Mil (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Mil_to_Grad (Normalize_to_Mil (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    New_Line;
  end loop;

  New_Line;
  Put_Line ("                         RADIANS          DEGREES       GRADIANS        MILS");
  Put_Line ("      TEST VALUE       Normalized        Converted     Converted      Converted");
  for I in Index loop
    Put (Test_Values (I), Exp => 0, Aft => 8, Fore => 8);
    Put (Three_Spaces);
    Put (Normalize_to_Rad (Test_Values (I)), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Rad_to_Deg (Normalize_to_Rad (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Rad_to_Grad (Normalize_to_Rad (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    Put (Three_Spaces);
    Put (Rad_to_Mil (Normalize_to_Rad (Test_Values (I))), Exp => 0, Aft => 8, Fore => 4);
    New_Line;
  end loop;

end Angles_Geometric_Normalization_and_Conversion;
