-- Rosetta Code Task written in Ada
-- ABC correlation
-- https://rosettacode.org/wiki/ABC_correlation
--
-- Assuming only lower case letters ('a' to 'z');
-- other ASCII characters encountered will be ignored
--
-- This was inspired by the Ada solution to ABC_Words
-- and the Raku solution to this task
--
-- Assumes the existence of the file "unixdict.txt" (or a symlink
-- to it) coexists with the Ada executable
--
-- July 2024, R. B. E. (preamble comments last updated 04 August 2024)

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;

procedure ABC_Correlation is

  function Test_Word (S : String) return Boolean is
    Count_A : Natural := 0;
    Count_B : Natural := 0;
    Count_C : Natural := 0;
    P1      : constant String := "" & 'a';
    P2      : constant String := "" & 'b';
    P3      : constant String := "" & 'c';
  begin
    Count_A := Count_A + Ada.Strings.Fixed.Count (Source  => S, Pattern => P1);
    Count_B := Count_B + Ada.Strings.Fixed.Count (Source  => S, Pattern => P2);
    Count_C := Count_C + Ada.Strings.Fixed.Count (Source  => S, Pattern => P3);
    if ((Count_A = Count_B) and then (Count_A = Count_C) and then (Count_A > 0)) then
      return True;
    else
      return False;
    end if;
  end Test_Word;

  Filename : constant String := "unixdict.txt";
  File     : File_Type;

begin
  Open (File, In_File, Filename);
  while not End_Of_File (File) loop
    declare
      Word : constant String := Get_Line (File);
    begin
      if Test_Word (Word) then
        Put_Line (Word);
      end if;
    end; -- declare
  end loop;
  Close (File);
end ABC_Correlation;
