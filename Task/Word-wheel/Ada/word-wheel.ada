with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
procedure Wordwheel is
   Compulsory_Ix : constant Positive := 5;
   Min_Length    : constant Positive := 3;

   function Char_Posn (Str : Unbounded_String; C : Character) return Natural is
   begin
      for Ix in 1 .. Length (Str) loop
         if Element (Str, Ix) = C then
            return Ix;
         end if;
      end loop;
      return 0;
   end Char_Posn;

   procedure Search (Dict_Filename : String; Wheel : String) is
      Dict_File     : File_Type;
      Allowed       : constant String := To_Lower (Wheel);
      Required_Char : constant String (1 .. 1) := "" & Allowed (Compulsory_Ix);
      Available, Dict_Word : Unbounded_String;
      Dict_Word_Len : Positive;
      Matched       : Boolean;
      Posn          : Natural;
   begin
      Open (File => Dict_File, Mode => In_File, Name => Dict_Filename);
      while not End_Of_File (Dict_File) loop
         Dict_Word := Get_Line (Dict_File);
         Dict_Word_Len := Length (Dict_Word);
         if Dict_Word_Len >= Min_Length and then
            Dict_Word_Len <= Wheel'Length and then
            Ada.Strings.Unbounded.Count (Dict_Word, Required_Char) > 0
         then
            Available := To_Unbounded_String (Allowed);
            Matched := True;
            for i in 1 .. Dict_Word_Len loop
               Posn := Char_Posn (Available, Element (Dict_Word, i));
               if Posn > 0 then
                  Delete (Source => Available, From => Posn, Through => Posn);
               else
                  Matched := False;
                  exit;
               end if;
            end loop;
            if Matched then
               Put_Line (Dict_Word);
            end if;
         end if;
      end loop;
      Close (Dict_File);
   end Search;
begin
   Search ("unixdict.txt", "ndeokgelw");
end Wordwheel;
