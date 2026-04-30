pragma Ada_2022;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Containers.Generic_Constrained_Array_Sort;
with Ada.Text_IO;  use Ada.Text_IO;

procedure Poker is

   type Face_T is (two, three, four, five, six, seven, eight, nine, t, j, q, k, a);
   for Face_T use (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
   type Suit_T is (C, D, H, S);
   type Card_T is record
      Face : Face_T;
      Suit : Suit_T;
   end record;

   subtype Hand_Index is Natural range 1 .. 5;
   type Hand_T is array (Hand_Index) of Card_T;
   type Test_Hand_Arr is array (Positive range <>) of Hand_T;
   type Pip_Counter_T is array (Face_T range Face_T'Range) of Natural;

   Pip_Counts : Pip_Counter_T := [others => 0];

   Test_Hands : Test_Hand_Arr := [
      1 => [(two, H), (two, D), (two, C), (k, S), (q, D)],
      2 => [(two, H), (five, H), (seven, D), (eight, C), (nine, S)],
      3 => [(a, H), (two, D), (three, C), (four, C), (five, D)],
      4 => [(two, H), (three, H), (two, D), (three, C), (three, D)],
      5 => [(two, H), (seven, H), (two, D), (three, C), (three, D)],
      6 => [(two, H), (seven, H), (seven, D), (seven, C), (seven, S)],
      7 => [(t, H), (j, H), (q, H), (k, H), (a, H)],
      8 => [(four, H), (four, S), (k, S), (five, D), (t, S)],
      9 => [(q, C), (t, C), (seven, C), (six, C), (q, C)]
   ];

   function "<" (L, R : Card_T) return Boolean is
   begin
      if L.Face = R.Face then
         return L.Suit < R.Suit;
      else
         return L.Face < R.Face;
      end if;
   end "<";

   procedure Sort_Hand is new Ada.Containers.Generic_Constrained_Array_Sort (Hand_Index, Card_T, Hand_T);

   procedure Print_Hand (Hand : Hand_T) is
   begin
      for Card of Hand loop
         if Card.Face < j then
            Put (Face_T'Enum_Rep (Card.Face)'Image);
         else
            Put (" " & To_Lower (Card.Face'Img));
         end if;
         Put (To_Lower (Card.Suit'Img));
      end loop;
   end Print_Hand;

   function Is_Invalid (Hand : Hand_T) return Boolean is
   begin
      for Ix in 2 .. 5 loop
         if Face_T'Pos (Hand (Ix).Face) = Face_T'Pos (Hand (Ix - 1).Face) and then
            Hand (Ix).Suit = Hand (Ix - 1).Suit
         then
            return True;
         end if;
      end loop;
      return False;
   end Is_Invalid;

   function Is_Flush (Hand : Hand_T) return Boolean is
   begin
      for Ix in 2 .. 5 loop
         if Hand (Ix).Suit /= Hand (1).Suit then
            return False;
         end if;
      end loop;
      return True;
   end Is_Flush;

   function Is_Straight (Hand : Hand_T) return Boolean is
   begin
      --  special case: Ace low
      if Hand (5).Face = a and then Hand (1).Face = two and then Hand (2).Face = three and then Hand (3).Face = four then
         return True;
      end if;
      for Ix in 2 .. 5 loop
         if Face_T'Pos (Hand (Ix).Face) /= Face_T'Pos (Hand (Ix - 1).Face) + 1 then
            return False;
         end if;
      end loop;
      return True;
   end Is_Straight;

   function Of_A_Kind (N : Positive) return Boolean is
   begin
      for Pip in two .. a loop
         if Pip_Counts (Pip) = N then
            return True;
         end if;
      end loop;
      return False;
   end Of_A_Kind;

   function Count_Pairs return Natural is
      Pairs : Natural := 0;
   begin
      for Pip in two .. a loop
         if Pip_Counts (Pip) = 2 then
            Pairs := Pairs + 1;
         end if;
      end loop;
      return Pairs;
   end Count_Pairs;

   Flush, Straight : Boolean;

begin

   for Hand of Test_Hands loop
      Print_Hand (Hand);
      Put (":");
      Set_Col (20);
      Sort_Hand (Hand); --  Print_Hand (Hand);
      if Is_Invalid (Hand) then
         Put ("invalid");
      else
         Flush := Is_Flush (Hand);
         Straight := Is_Straight (Hand);
         if Flush and Straight then
            Put ("straight-flush");
         else
            for Pip in two .. a loop
               Pip_Counts (Pip) := 0;
               for Card of Hand loop
                  if Card.Face = Pip then
                     Pip_Counts (Pip) := Pip_Counts (Pip) + 1;
                  end if;
               end loop;
            end loop;
            if Of_A_Kind (4) then
               Put ("four-of-a-kind");
            elsif Of_A_Kind (3) and then Of_A_Kind (2) then
               Put ("full-house");
            elsif Flush then
               Put ("flush");
            elsif Straight then
               Put ("straight");
            elsif Of_A_Kind (3) then
               Put ("three-of-a-kind");
            else
               case Count_Pairs is
                  when 2 => Put ("two-pairs");
                  when 1 => Put ("one-pair");
                  when others => Put ("high-card");
               end case;
            end if;
         end if;
      end if;
      Put_Line ("");
   end loop;

end Poker;
