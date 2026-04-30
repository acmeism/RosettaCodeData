-- Play the card game War
-- J. Carter     2024 Jul
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Ansi_Tty_Control;
with PragmARC.Cards.Decks.US;
with PragmARC.Cards.US;

procedure War is
   package Ansi  renames PragmARC.Ansi_Tty_Control;
   package Cards renames PragmARC.Cards.US;
   package Decks renames PragmARC.Cards.Decks.US;

   use type Cards.Rank_Id;

   procedure Display (Hand1 : in Decks.Deck_52; Hand2 : in Decks.Deck_52);
   -- Display the state of the game represented by the 2 hands

   function ">" (Left : in Cards.Card_Info; Right : in Cards.Card_Info) return Boolean is
      (if Left.Rank = Cards.Ace then
          Right.Rank /= Cards.Ace
       elsif Right.Rank = Cards.Ace then
          False
       else
          Left.Rank > Right.Rank);

   procedure Display (Hand1 : in Decks.Deck_52; Hand2 : in Decks.Deck_52) is
      function Image (Card : in Cards.Card_Info) return Character is
         (Cards.Image (Card) (1) );

      procedure Display (Hand : in Decks.Deck_52);
      -- Puts the ranks of the cards in Hand in a row

      procedure Display (Hand : in Decks.Deck_52) is
         -- Empty
      begin -- Display
         All_Cards : for I in 1 .. Hand.Size loop
            Ada.Text_IO.Put (Item => Image (Hand.Value (I) ) );
         end loop All_Cards;
      end Display;
   begin -- Display
      Ada.Text_IO.Put (Item => Ansi.Clear_Screen);
      Display (Hand => Hand1);
      Ada.Text_IO.Put (Item => Ansi.Position (2, 1) );
      Display (Hand => Hand2);
      Ada.Text_IO.Put (Item => Ansi.Position (3, 1) );
   end Display;

   Hand1 : Decks.Deck_52;   -- Player 1
   Hand2 : Decks.Deck_52;   -- Player 2
   Card1 : Cards.Card_Info; -- Player 1
   Card2 : Cards.Card_Info; -- Player 2
   War1  : Decks.Deck_52;   -- Player 1
   War2  : Decks.Deck_52;   -- Player 2
begin -- War
   Decks.Standard_Deck (Item => Hand1);
   Hand1.Shuffle;

   Deal : for I in 1 .. Hand1.Size / 2 loop -- Each player gets half the deck
      Hand1.Deal (To => Card1);
      Hand2.Add (Item => Card1);
   end loop Deal;

   Play : loop
      Display (Hand1 => Hand1, Hand2 => Hand2);

      exit Play when Hand1.Size = 0 or Hand2.Size = 0;

      delay 0.5;

      Hand1.Deal (To => Card1);
      Hand2.Deal (To => Card2);

      if Card1.Rank /= Card2.Rank then
         if Card1 > Card2 then
            Hand1.Add (Item => Card1);
            Hand1.Add (Item => Card2);
         else
            Hand2.Add (Item => Card2);
            Hand2.Add (Item => Card1);
         end if;
      else -- War!
         War1.Add (Item => Card1);
         War2.Add (Item => Card2);

         All_Tries : loop
            Ada.Text_IO.Put (Item => "W^^");

            delay 0.5;

            Deal1 : for I in 1 .. 2 loop
               exit Deal1 when Hand1.Is_Empty;

               Hand1.Deal (To => Card1);
               War1.Add (Item => Card1);
            end loop Deal1;

            Deal2 : for I in 1 .. 2 loop
               exit Deal2 when Hand2.Is_Empty;

               Hand2.Deal (To => Card2);
               War2.Add (Item => Card2);
            end loop Deal2;

            if War1.Value (War1.Size) > War2.Value (War2.Size) then -- 1 wins
               Deal11 : loop
                  exit Deal11 when War1.Is_Empty;

                  War1.Deal (To => Card1);
                  Hand1.Add (Item => Card1);
               end loop Deal11;

               Deal12 : loop
                  exit Deal12 when War2.Is_Empty;

                  War2.Deal (To => Card1);
                  Hand1.Add (Item => Card1);
               end loop Deal12;

               exit All_Tries;
            elsif War2.Value (War2.Size) > War1.Value (War1.Size) then -- 2 Wins
               Deal22 : loop
                  exit Deal22 when War2.Is_Empty;

                  War2.Deal (To => Card2);
                  Hand2.Add (Item => Card2);
               end loop Deal22;

               Deal21 : loop
                  exit Deal21 when War1.Is_Empty;

                  War1.Deal (To => Card2);
                  Hand2.Add (Item => Card2);
               end loop Deal21;

               exit All_Tries;
            else
               null; -- The war continues
            end if;
         end loop All_Tries;
      end if;
   end loop Play;

   Ada.Text_IO.Put (Item => "Player " & (if Hand1.Size = 0 then '2' else '1') & " wins");
end War;
