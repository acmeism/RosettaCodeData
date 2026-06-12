with Ada.Text_Io;
with Ada.Containers.Indefinite_Ordered_Maps;

procedure Odd_Words is
   use Ada.Text_Io;

   package String_Maps is
     new Ada.Containers.Indefinite_Ordered_Maps (Key_Type     => String,
                                                 Element_Type => String);

   Filename : constant String := "unixdict.txt";
   Words    : String_Maps.Map;

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

   generic
      with function Filter (Word : String) return String;
   procedure Iterate_Map;

   procedure Iterate_Map is
   begin
      for Word of Words loop
         declare
            Half : constant String := Filter (Word);
         begin
            if Half'Length > 4 and then Words.Contains (Half) then
               Put (Word); Set_Col (15); Put_Line (Half);
            end if;
         end;
      end loop;
   end Iterate_Map;

   procedure Put_Odd_Words  is new Iterate_Map (Get_Odd);
   procedure Put_Even_Words is new Iterate_Map (Get_Even);

   File : File_Type;
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

   Put_Line ("Odd words:");
   Put_Odd_Words;
   New_Line;

   Put_Line ("Even words:");
   Put_Even_Words;
end Odd_Words;
