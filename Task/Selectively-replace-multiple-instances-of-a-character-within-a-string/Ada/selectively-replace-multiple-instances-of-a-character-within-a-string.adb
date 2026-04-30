-- Selectively replace multiple instances of a character within a string
-- J. Carter     2024 Jun

with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure Selectively_Replace is
   procedure Replace
      (Letter : in Character; Occurrence : in Positive; Within : in String; By : in Character; Into : in out String)
   with Pre => Into'First = Within'First and Into'Last = Within'Last;
   -- Finds the index of the Occurrence-th instance of Letter in Within and sets the character in Into at that index to By
   -- If there is no such index, has no effect
   -- Before the first call to replace, Within should be = Into

   procedure Replace
      (Letter : in Character; Occurrence : in Positive; Within : in String; By : in Character; Into : in out String)
   is
      Start : Natural := 0;
   begin -- Replace
      Find : for I in 1 .. Occurrence loop
         Start := Ada.Strings.Fixed.Index (Within, Letter & "", Start + 1);

         if Start = 0 then -- Within has fewer than Occurrence instances of Letter
            return;
         end if;
      end loop Find;

      Into (Start) := By;
   end Replace;

   Source : constant String := "abracadabra";

   Result : String := Source;
begin -- Selectively_Replace
   Replace (Letter => 'a', Occurrence => 1, Within => Source, By => 'A', Into => Result);
   Replace (Letter => 'a', Occurrence => 2, Within => Source, By => 'B', Into => Result);
   Replace (Letter => 'a', Occurrence => 4, Within => Source, By => 'C', Into => Result);
   Replace (Letter => 'a', Occurrence => 5, Within => Source, By => 'D', Into => Result);
   Replace (Letter => 'b', Occurrence => 1, Within => Source, By => 'E', Into => Result);
   Replace (Letter => 'r', Occurrence => 2, Within => Source, By => 'F', Into => Result);
   Ada.Text_IO.Put_Line (Item => Source & " => " & Result);
end Selectively_Replace;
