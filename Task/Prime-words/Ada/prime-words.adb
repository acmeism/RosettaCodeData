-- Rosetta Code Task written in Ada
-- Task Name: Prime words
-- Task URL: https://rosettacode.org/wiki/Prime_words
-- August 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Prime_Words is

  procedure Get_Word is

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

    procedure Split_Word (W : String) is
      Count_of_Prime_Letters : Natural := 0;
    begin
      for C in W'Range loop
        if (Is_Prime (Character'Pos (W (C)))) then
          Count_of_Prime_Letters := Count_of_Prime_Letters + 1;
        end if;
      end loop;
      if (W'Last = Count_of_Prime_Letters) then
        Put_Line (W);
      end if;
    end;

    File : File_Type;

  begin
    Open (File => File, Mode => In_File, Name => "unixdict.txt");
    while not End_Of_File (File) Loop
      Split_Word (Get_Line (File));
    end loop;
    Close (File);
  end Get_Word;

begin
  Get_Word;
end Prime_Words;
