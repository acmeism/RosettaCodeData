with Ada.Text_Io;
with Ada.Containers.Indefinite_Ordered_Maps;

procedure Alternade_Words is
   use Ada.Text_Io;

   package String_Maps is
     new Ada.Containers.Indefinite_Ordered_Maps (Key_Type     => String,
                                                 Element_Type => String);

   function Get_Odd (Word : String) return String is
      Odd : String (1 .. (Word'Length + 1) / 2);
   begin
      for Index in Odd'Range loop
         Odd (Index) := Word (1 + 2 * (Index - 1));
      end loop;
      return Odd;
   end Get_Odd;

   function Get_Even (Word : String) return String is
      Even : String (1 .. Word'Length / 2);
   begin
      for Index in Even'Range loop
         Even (Index) := Word (1 + 1 + 2 * (Index - 1));
      end loop;
      return Even;
   end Get_Even;

   Filename : constant String := "unixdict.txt";
   Words    : String_Maps.Map;
   File     : File_Type;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word : constant String := Get_Line (File);
      begin
         Words.Insert (Word, Word);
      end;
   end loop;
   Close (File);

   for Word of Words loop
      declare
         Odd  : constant String := Get_Odd  (Word);
         Even : constant String := Get_Even (Word);
      begin
         if
           Word'Length >= 6       and then
             Words.Contains (Odd) and then
             Words.Contains (Even)
         then
            Put (Word);
            Set_Col (15); Put (Odd);
            Set_Col (25); Put (Even);
            New_Line;
         end if;
      end;
   end loop;
end Alternade_Words;
