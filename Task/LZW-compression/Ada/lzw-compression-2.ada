with Ada.Containers.Ordered_Maps;
with Ada.Strings.Unbounded;

package body LZW is
   package UStrings renames Ada.Strings.Unbounded;
   use type UStrings.Unbounded_String;

   --------------
   -- Compress --
   --------------

   function Compress (Cleartext : in String) return Compressed_Data is
      -- translate String to Code-ID
      package String_To_Code is new Ada.Containers.Ordered_Maps (
         Key_Type => UStrings.Unbounded_String,
         Element_Type => Codes);

      Dictionary : String_To_Code.Map;
      -- Next unused Code-ID
      Next_Entry : Codes := 256;

      -- maximum same length as input, compression ratio always >=1.0
      Result : Compressed_Data (1 .. Cleartext'Length);
      -- position for next Code-ID
      Result_Index : Natural := 1;

      -- current and next input string
      Current_Word : UStrings.Unbounded_String :=
        UStrings.Null_Unbounded_String;
      Next_Word    : UStrings.Unbounded_String :=
        UStrings.Null_Unbounded_String;
   begin
      -- initialize Dictionary
      for C in Character loop
         String_To_Code.Insert
           (Dictionary,
            UStrings.Null_Unbounded_String & C,
            Character'Pos (C));
      end loop;

      for Index in Cleartext'Range loop
         -- add character to current word
         Next_Word := Current_Word & Cleartext (Index);
         if String_To_Code.Contains (Dictionary, Next_Word) then
            -- already in dictionary, continue with next character
            Current_Word := Next_Word;
         else
            -- insert code for current word to result
            Result (Result_Index) :=
               String_To_Code.Element (Dictionary, Current_Word);
            Result_Index          := Result_Index + 1;
            -- add new Code to Dictionary
            String_To_Code.Insert (Dictionary, Next_Word, Next_Entry);
            Next_Entry := Next_Entry + 1;
            -- reset current word to one character
            Current_Word := UStrings.Null_Unbounded_String &
                            Cleartext (Index);
         end if;
      end loop;
      -- Last word was not entered
      Result (Result_Index) :=
         String_To_Code.Element (Dictionary, Current_Word);
      -- return correct array size
      return Result (1 .. Result_Index);
   end Compress;

   ----------------
   -- Decompress --
   ----------------

   function Decompress (Data : in Compressed_Data) return String is
      -- translate Code-ID to String
      type Code_To_String is array (Codes) of UStrings.Unbounded_String;

      Dictionary : Code_To_String;
      -- next unused Code-ID
      Next_Entry : Codes := 256;

      -- initialize resulting string as empty string
      Result : UStrings.Unbounded_String := UStrings.Null_Unbounded_String;

      Next_Code : Codes;
      -- first code has to be in dictionary
      Last_Code : Codes := Data (1);
      -- suffix appended to last string for new dictionary entry
      Suffix : Character;
   begin
      -- initialize Dictionary
      for C in Character loop
         Dictionary (Codes (Character'Pos (C)))   :=
           UStrings.Null_Unbounded_String & C;
      end loop;

      -- output first Code-ID
      UStrings.Append (Result, Dictionary (Last_Code));
      for Index in 2 .. Data'Last loop
         Next_Code := Data (Index);
         if Next_Code <= Next_Entry then
            -- next Code-ID already in dictionary -> append first char
            Suffix := UStrings.Element (Dictionary (Next_Code), 1);
         else
            -- next Code-ID not in dictionary -> use char from last ID
            Suffix := UStrings.Element (Dictionary (Last_Code), 1);
         end if;
         -- expand the dictionary
         Dictionary (Next_Entry) := Dictionary (Last_Code) & Suffix;
         Next_Entry              := Next_Entry + 1;
         -- output the current Code-ID to result
         UStrings.Append (Result, Dictionary (Next_Code));
         Last_Code := Next_Code;
      end loop;
      -- return String
      return UStrings.To_String (Result);
   end Decompress;

end LZW;
