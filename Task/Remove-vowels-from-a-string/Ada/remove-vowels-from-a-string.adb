with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
   subtype Vowel is Character with
        Static_Predicate => Vowel in 'A' | 'E' | 'I' | 'O' | 'U' | 'a' | 'e' |
            'i' | 'o' | 'u';

   function Remove_Vowels (S : in String) return String is
      Temp : Unbounded_String;
   begin
      for C of S loop
         if C not in Vowel then
            Append (Source => Temp, New_Item => C);
         end if;
      end loop;
      return To_String (Temp);
   end Remove_Vowels;

   S1  : String := "The Quick Brown Fox Jumped Over the Lazy Dog's Back";
   S2  : String := "DON'T SCREAM AT ME!!";
   NV1 : String := Remove_Vowels (S1);
   NV2 : String := Remove_Vowels (S2);
begin
   Put_Line (S1);
   Put_Line (NV1);
   New_Line;
   Put_Line (S2);
   Put_Line (NV2);
end Main;
