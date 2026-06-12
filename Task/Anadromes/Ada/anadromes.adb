-- Find all anadromes of length > 6
-- J. Carter     2023 Mar

with Ada.Containers.Indefinite_Ordered_Sets;
with Ada.Text_IO;

procedure Anadromes is
   package Word_Sets is new Ada.Containers.Indefinite_Ordered_Sets (Element_Type => String);

   function Reversed (S : in String) return String is
      (if S = "" then S else S (S'Last) & Reversed (S (S'First .. S'Last - 1) ) );

   File : Ada.Text_IO.File_Type;
   W    : Word_Sets.Set;
begin -- Anadromes
   Ada.Text_IO.Open (File => File, Mode => Ada.Text_IO.In_File, Name => "words.txt");

   Fill : loop
      exit Fill when Ada.Text_IO.End_Of_File (File);

      W.Insert (New_Item => Ada.Text_IO.Get_Line (File) );
   end loop Fill;

   Ada.Text_IO.Close (File => File);

   Search : for Word of W loop
      if Word'Length > 6 then
         Backwards : declare
            Rev : constant String := Reversed (Word);
         begin -- Backwards
            if Word < Rev and W.Contains (Rev) then
               Ada.Text_IO.Put_Line (Item => Word & (1 .. 10 - Word'Length => ' ') & Rev);
            end if;
         end Backwards;
      end if;
   end loop Search;
end Anadromes;
