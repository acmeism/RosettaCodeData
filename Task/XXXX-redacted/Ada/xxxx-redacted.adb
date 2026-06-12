-- Redact text
-- J. Carter     2023 Apr

with Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure Redact is
   use Ada.Strings.Unbounded;

   package Field_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Unbounded_String);

   function Parsed (Line : String) return Field_Lists.Vector;
   -- Presumes that Line consists of fields speparated by 1 or more spaces (' ')
   -- Returns a list of the parsed fields

   function Redact (Word           : in Field_Lists.Vector;
                    Pattern        : in String;
                    Whole_Word     : in Boolean;
                    Case_Sensitive : in Boolean;
                    Overkill       : in Boolean)
   return String;
   -- Redacts the words or parts of words in Word containing Pattern
   -- If Whole_Word, the entire word must match Pattern, and Overkill is ignored
   -- Case_Sensitive determines whether or not the match is case sensitive
   -- Overkill means the entire word is redacted even if only a part matches

   function Parsed (Line : String) return Field_Lists.Vector is
      Result : Field_Lists.Vector;
      Start  : Natural := Line'First;
      Stop   : Natural;
   begin -- Parsed
      All_Fields : loop
         Start := Ada.Strings.Fixed.Index_Non_Blank (Line (Start .. Line'Last) );

         exit All_Fields when Start = 0;

         Stop := Ada.Strings.Fixed.Index (Line (Start .. Line'Last), " ");

         if Stop = 0 then
            Stop := Line'Last + 1;
         end if;

         Result.Append (New_Item => To_Unbounded_String (Line (Start .. Stop - 1) ) );
         Start := Stop + 1;
      end loop All_Fields;

      return Result;
   end Parsed;

   function Redact (Word           : in Field_Lists.Vector;
                    Pattern        : in String;
                    Whole_Word     : in Boolean;
                    Case_Sensitive : in Boolean;
                    Overkill       : in Boolean)
   return String is
      subtype Lower is Character range 'a' .. 'z';
      subtype Upper is Character range 'A' .. 'Z';

      Pat : constant String := (if Case_Sensitive then Pattern else Ada.Characters.Handling.To_Lower (Pattern) );

      Result : Unbounded_String;
      Start  : Positive; -- Start of a word, ignoring initial punctuation
      Stop   : Positive; -- End of a word, ignoring terminal punctuation
      First  : Natural;  -- Start of partial match
      Last   : Natural;  -- End of partial match
   begin -- Redact
      All_Words : for I in 1 .. Word.Last_Index loop
         One_Word : declare
            Raw  : String := To_String (Word.Element (I) );
            Woid : String := (if Case_Sensitive then Raw else Ada.Characters.Handling.To_Lower (Raw) );
         begin -- One_Word
            Start := Woid'First; -- Ignore initial punctuation

            Find_Start : loop
               exit Find_Start when Woid (Start) in Lower | Upper;

               Start := Start + 1;
            end loop Find_Start;

            Stop := Woid'Last; -- Ignore terminal punctuation

            Find_Stop : loop
               exit Find_Stop when Woid (Stop) in Lower | Upper;

               Stop := Stop - 1;
            end loop Find_Stop;

            if Whole_Word then
               if Woid (Start .. Stop) = Pat then
                  Raw (Start .. Stop) := (Start .. Stop => 'X');
               end if;
            else
               Last := Start - 1;

               All_Matches : loop -- Multiple matches are possible within a single word
                  First := Ada.Strings.Fixed.Index (Woid (Last + 1 .. Stop), Pat);

                  exit All_Matches when First = 0;

                  Last := (if Overkill then Stop else First + Pattern'Length - 1);

                  if Overkill then
                     First := Start;
                  end if;

                  Raw (First .. Last) := (First .. Last => 'X');
               end loop All_Matches;
            end if;

            Append (Source => Result, New_Item => Raw & (if I = Word.Last_Index then "" else " ") );
         end One_Word;
      end loop All_Words;

      return To_String (Result);
   end Redact;

   subtype Pattern_String is String (1 .. 3);
   type Pattern_List is array (1 .. 2) of Pattern_String;

   Pattern : constant Pattern_List := ("Tom", "tom");

   Line : constant String := "Tom? Toms bottom tomato is in his stomach while playing the " & '"' & "Tom-tom" & '"' &
                             " brand tom-toms. That's so tom.";
   Word : constant Field_Lists.Vector := Parsed (Line);
begin -- Redact
   All_Patterns : for Pat of Pattern loop
      Ada.Text_IO.Put_Line (Item => "Pattern: " & Pat);

      Wholeness : for Whole in Boolean loop
         Sensitivity : for Sense in Boolean loop
            if Whole then
               Ada.Text_IO.Put_Line (Item => 'W' & (if Sense then 'S' else 'I') & "N: " & Redact (Word, Pat, Whole, Sense, False) );
            else
               Overkill : for Over in Boolean loop
                  Ada.Text_IO.Put_Line (Item => (if Whole then 'W' else 'P') &
                                                (if Sense then 'S' else 'I') &
                                                (if Over  then 'O' else 'N') & ": " &
                                                Redact (Word, Pat, Whole, Sense, Over) );
               end loop Overkill;
            end if;
         end loop Sensitivity;
      end loop Wholeness;
   end loop All_Patterns;
end Redact;
