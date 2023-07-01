package Morse is

   type Symbols is (Nul, '-', '.', ' ');
   -- Nul is the letter separator, space the word separator;
   Dash : constant Symbols := '-';
   Dot : constant Symbols := '.';
   type Morse_Str is array (Positive range <>) of Symbols;
   pragma Pack (Morse_Str);

   function Convert (Input : String) return Morse_Str;
   procedure Morsebeep (Input : Morse_Str);

private
   subtype Reschars is Character range ' ' .. 'Z';
   -- restricted set of characters from 16#20# to 16#60#
   subtype Length is Natural range 1 .. 5;
   subtype Codes is Morse_Str (Length);
   -- using the current ITU standard with 5 signs
   -- only alphanumeric characters  are taken into consideration

   type Codings is record
      L : Length;
      Code : Codes;
   end record;
   Table : constant array (Reschars) of Codings :=
     ('A' => (2, ".-   "), 'B' => (4, "-... "),  'C' => (4, "-.-. "),
      'D' => (3, "-..  "), 'E' => (1, ".    "),  'F' => (4, "..-. "),
      'G' => (3, "--.  "), 'H' => (4, ".... "),  'I' => (2, "..   "),
      'J' => (4, ".--- "), 'K' => (3, "-.-  "),  'L' => (4, ".-.. "),
      'M' => (2, "--   "), 'N' => (2, "-.   "),  'O' => (3, "---  "),
      'P' => (4, ".--. "), 'Q' => (4, "--.- "),  'R' => (3, ".-.  "),
      'S' => (3, "...  "), 'T' => (1, "-    "),  'U' => (3, "..-  "),
      'V' => (4, "...- "), 'W' => (3, ".--  "),  'X' => (4, "-..- "),
      'Y' => (4, "-.-- "), 'Z' => (4, "--.. "),  '1' => (5, ".----"),
      '2' => (5, "..---"), '3' => (5, "...--"),  '4' => (5, "....-"),
      '5' => (5, "....."), '6' => (5, "-...."),  '7' => (5, "--..."),
      '8' => (5, "---.."), '9' => (5, "----."),  '0' => (5, "-----"),
      others => (1, "     ")); -- Dummy => Other characters do not need code.

end Morse;
