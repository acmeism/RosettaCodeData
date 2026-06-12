--
-- count vowels and consonants in a string
--
with Ada.Text_IO; use Ada.Text_IO;

procedure count_vowels_and_consonants is
   subtype letter is Character with
        Static_Predicate => letter in 'A' .. 'Z' | 'a' .. 'z';
   subtype Vowel is Character with
        Static_Predicate => Vowel in 'A' | 'E' | 'I' | 'O' | 'U' | 'a' | 'e' |
            'i' | 'o' | 'u';
   subtype consonant is Character with
        Dynamic_Predicate => consonant in letter
        and then consonant not in Vowel;

   Input           : String (1 .. 1_024);
   length          : Natural;
   consonant_count : Natural := 0;
   vowel_count     : Natural := 0;
begin
   Put ("Enter a string: ");
   Get_Line (Item => Input, Last => length);
   -- count consonants
   for char of Input (1 .. length) loop
      if char in consonant then
         consonant_count := consonant_count + 1;
      elsif char in Vowel then
         vowel_count := vowel_count + 1;
      end if;
   end loop;
   Put_Line ('"' & Input (1 .. length) & '"');
   Put_Line
     ("contains" & vowel_count'Image & " vowels and" & consonant_count'Image &
      " consonants.");
end count_vowels_and_consonants;
