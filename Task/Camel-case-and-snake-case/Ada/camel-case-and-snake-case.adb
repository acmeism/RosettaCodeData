with Ada.Characters.Handling,
     Ada.Strings,
     Ada.Strings.Fixed,
     Ada.Strings.Maps,
     Ada.Strings.Maps.Constants,
     Ada.Text_IO;

use Ada.Characters.Handling,
    Ada.Strings,
    Ada.Strings.Fixed,
    Ada.Strings.Maps,
    Ada.Strings.Maps.Constants;

procedure Camel_Snake_Case is
   type Sample_Array is array (Positive range <>) of access constant String;
   --  Work around for array elements needing to be the same size.
   --  Could also use Ada.Strings.Bounded_Strings instead.
   S1 : aliased constant String := "snakeCase";
   S2 : aliased constant String := "snake_case";
   S3 : aliased constant String := "variable_10_case";
   S4 : aliased constant String := "variable10Case";
   S5 : aliased constant String := "ɛrgo rE tHis";
   S6 : aliased constant String := "hurry-up-joe!";
   S7 : aliased constant String := "c://my-docs/happy_Flag-Day/12.doc";
   S8 : aliased constant String := "  spaces  ";

   Samples : constant Sample_Array :=
     (
       S1'Access,
       S2'Access,
       S3'Access,
       S4'Access,
       S5'Access,
       S6'Access,
       S7'Access,
       S8'Access
     );

   function Should_Insert (This, Last : Character) return Boolean is
     (
      (Is_In (Last, Lower_Set) and then
       Is_In (This, Upper_Set or Decimal_Digit_Set))
      or else
      (Is_In (Last, Upper_Set) and then
       Is_In (This, Decimal_Digit_Set))
      or else
      (Is_In (Last, Decimal_Digit_Set) and then
       Is_In (This, Upper_Set))
     );

   function To_Snake_Case (S : String) return String is
      Trimmed : constant String := Trim (S, Both);
      Separator_Map : constant Character_Mapping := To_Mapping (" -", "__");
      Translated : constant String := Translate (Trimmed, Separator_Map);
      New_Word_Set : constant Character_Set := Upper_Set or Decimal_Digit_Set;
      New_Word_Chars : constant Natural := Count (Translated, New_Word_Set);
      Snake : String (1 .. Translated'Length + New_Word_Chars);
      J : Positive := 2;
      L : Character;
   begin
      Snake (1 .. Translated'Length) := Translated;

      for I in 2 .. Translated'Last loop
         if Should_Insert (Translated (I), Translated (I - 1)) then
            Snake (J) := '_';
            J := J + 1;
         end if;

         L := Translated (I);

         if Is_In (Translated (I), Upper_Set) then
            L := To_Lower (L);
         end if;

         Snake (J) := L;
         J := J + 1;
      end loop;

      return Snake (1 .. J - 1);
   end To_Snake_Case;

   function To_Camel_Case (S : String) return String is
      Trimmed : constant String := Trim (S, Both);
      Separators : constant Character_Set := To_Set (" -_");
      Snake : String (Trimmed'Range) := Trimmed;
      J : Positive := 2;
   begin
      for I in 2 .. Trimmed'Length loop
         if not Is_In (Trimmed (I), Separators) then
            if Is_In (Trimmed (I - 1), Separators) and then
               Is_In (Trimmed (I), Lower_Set) then
               Snake (J) := To_Upper (Trimmed (I));
            else
               Snake (J) := Trimmed (I);
            end if;

            J := J + 1;
         end if;
      end loop;

      return Snake (1 .. J - 1);
   end To_Camel_Case;

begin
   Ada.Text_IO.Put_Line ("=Snake Case=");
   for I of Samples loop
      Ada.Text_IO.Put_Line (I.all & " => " & To_Snake_Case (I.all));
   end loop;

   Ada.Text_IO.Put_Line ("=Camel Case=");
   for I of Samples loop
      Ada.Text_IO.Put_Line (I.all & " => " & To_Camel_Case (I.all));
   end loop;
end Camel_Snake_Case;
