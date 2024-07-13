-- Check the "Mind boggling card trick"
-- J. Carter     2024 May
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with PragmARC.Cards.Decks.US;
with PragmARC.Cards.US;

procedure Card_Trick is
   package Cards renames PragmARC.Cards.US;
   package Decks renames PragmARC.Cards.Decks.US;

   function Is_Red (Card : in Cards.Card_Info) return Boolean is
      (Card.Suit in Cards.Diamond | Cards.Heart);

   function Correct return Boolean;
   -- Performs the trick and returns True if the assertion that 'The number of black cards in the "black" pile equals the number
   -- of red cards in the "red" pile' holds; False if it does not

   function Correct return Boolean is
      function Num_Red (Deck : in Decks.Deck_52) return Natural;
      -- Returns the number of red cards in Deck

      function Num_Black (Deck : in Decks.Deck_52) return Natural;
      -- Returns the number of black cards in Deck

      function Num_Red (Deck : in Decks.Deck_52) return Natural is
         Result : Natural := 0;
      begin -- Num_Red
         Count : for I in 1 .. Deck.Size loop
            if Is_Red (Deck.Value (I) ) then
               Result := Result + 1;
            end if;
         end loop Count;

         return Result;
      end Num_Red;

      function Num_Black (Deck : in Decks.Deck_52) return Natural is
         (Deck.Size - Num_Red (Deck) );

      Hand  : Decks.Deck_52;
      Red   : Decks.Deck_52;
      Black : Decks.Deck_52;
      Card  : Cards.Card_Info;
   begin -- Correct
      Decks.Standard_Deck (Item => Hand);
      Hand.Shuffle;

      All_Cards : loop
         exit All_Cards when Hand.Is_Empty;

         Hand.Deal (To => Card);

         if Is_Red (Card) then
            Hand.Deal (To => Card);
            Red.Add (Item => Card);
         else
            Hand.Deal (To => Card);
            Black.Add (Item => Card);
         end if;
      end loop All_Cards;

      Swap : declare
         Number : constant Natural := Integer'Min (Red.Size, Black.Size) - 1;

         subtype Bunch_Value is Integer range 1 .. Number;

         package Random is new Ada.Numerics.Discrete_Random (Result_Subtype => Bunch_Value);

         Gen   : Random.Generator;
         Bunch : Bunch_Value;
      begin -- Swap
         Random.Reset (Gen => Gen);
         Bunch := Random.Random (Gen);

         One_Bunch : for I in 1 .. Bunch loop
            Red.Deal (To => Card);
            Black.Add (Item => Card);
            Black.Deal (To => Card);
            Red.Add (Item => Card);
         end loop One_Bunch;

         return Num_Red (Red) = Num_Black (Black);
      end Swap;
   end Correct;

   Total : constant := 10_000;

   Good  : Natural := 0;
begin -- Card_Trick
   Check_All : for I in 1 .. Total loop
      if Correct then
         Good := Good + 1;
      end if;
   end loop Check_All;

   Ada.Text_IO.Put_Line (Item => Good'Image & " correct out of" & Total'Image & " tries");
end Card_Trick;
