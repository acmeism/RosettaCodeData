with Ada.Strings.Maps, Ada.Characters.Handling, Interfaces.C;
use  Ada, Ada.Strings, Ada.Strings.Maps, Interfaces;

package body Morse is

   Dit, Dah, Lettergap, Wordgap : Duration; -- in seconds
   Dit_ms, Dah_ms : C.unsigned; -- durations expressed in ms
   Freq : constant C.unsigned := 1280; -- in Herz

   Morse_Sequence : constant Character_Sequence :=
      " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
   Morse_charset : constant Character_Set := To_Set (Morse_Sequence);

   function Convert (Input : String) return Morse_Str is
      Cap_String : constant String := Characters.Handling.To_Upper (Input);
      Result : Morse_Str (1 .. 7 * Input'Length); -- Upper Capacity
      First, Last : Natural := 0;
      Char_code : Codings;
   begin
      for I in Cap_String'Range loop
         if Is_In (Cap_String (I), Morse_charset) then
            First := Last + 1;
            if Cap_String (I) = ' ' then
               Result (First) := ' ';
               Last := Last + 1;
            else
               Char_code := Table (Reschars (Cap_String (I)));
               Last := First + Char_code.L - 1;
               Result (First .. Last) := Char_code.Code (1 .. Char_code.L);
               Last := Last + 1;
               Result (Last) := Nul;
            end if;
         end if;
      end loop;
      if Result (Last) /= ' ' then
         Last := Last + 1;
         Result (Last) := ' ';
      end if;
      return Result (1 .. Last);
   end Convert;

   procedure Morsebeep (Input : Morse_Str) is
      -- Beep is not portable : adapt to your OS/sound board
      -- Implementation for Windows XP / interface to fn in stdlib
      procedure win32xp_beep
        (dwFrequency : C.unsigned;
         dwDuration : C.unsigned);
      pragma Import (C, win32xp_beep, "_beep");
   begin
      for I in Input'Range loop
         case Input (I) is
            when Nul =>
               delay Lettergap;
            when Dot =>
               win32xp_beep (Freq, Dit_ms);
               delay Dit;
            when Dash =>
               win32xp_beep (Freq, Dah_ms);
               delay Dit;
            when ' ' =>
               delay Wordgap;
         end case;
      end loop;
   end Morsebeep;
begin
   Dit := 0.20;
   Lettergap := 2 * Dit;
   Dah := 3 * Dit;
   Wordgap := 4 * Dit;
   Dit_ms := C.unsigned (Integer (Dit * 1000));
   Dah_ms := C.unsigned (Integer (Dah * 1000));
end Morse;
