<with Ada.Text_IO, Simple_Parse;

procedure Phrase_Reversal is

   function Reverse_String (Item : String) return String is
      Result : String (Item'Range);
   begin
      for I in Item'range loop
         Result (Result'Last - I + Item'First) := Item (I);
      end loop;
      return Result;
   end Reverse_String;

   function Reverse_Words(S: String) return String is
      Cursor: Positive := S'First;
      Word: String := Simple_Parse.Next_Word(S, Cursor);
   begin
      if Cursor > S'Last then -- Word holds the last word
	 return Reverse_String(Word);
      else
	 return Reverse_String(Word) & " " & Reverse_Words(S(Cursor .. S'Last));
      end if;
   end Reverse_Words;

   function Reverse_Order(S: String) return String is
      Cursor: Positive := S'First;
      Word: String := Simple_Parse.Next_Word(S, Cursor);
   begin
      if Cursor > S'Last then -- Word holds the last word
	 return Word;
      else
	 return Reverse_Order(S(Cursor .. S'Last)) & " " & Word;
      end if;
   end Reverse_Order;

   Phrase: String := "rosetta code phrase reversal";
   use Ada.Text_IO;
begin
   Put_Line("0. The original phrase:       """ & Phrase & """");
   Put_Line("1. Reverse the entire phrase: """ & Reverse_String(Phrase) & """");
   Put_Line("2. Reverse words, same order: """ & Reverse_Words(Phrase) & """");
   Put_Line("2. Reverse order, same words: """ & Reverse_Order(Phrase) & """");
end Phrase_Reversal;
