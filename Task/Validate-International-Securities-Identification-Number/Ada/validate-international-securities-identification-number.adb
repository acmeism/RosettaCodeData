procedure ISIN is
   -- Luhn_Test copied from other Task
   function Luhn_Test (Number: String) return Boolean is
      Sum  : Natural := 0;
      Odd  : Boolean := True;
      Digit: Natural range 0 .. 9;
   begin
      for p in reverse Number'Range loop
         Digit := Integer'Value (Number (p..p));
         if Odd then
            Sum := Sum + Digit;
         else
            Sum := Sum + (Digit*2 mod 10) + (Digit / 5);
         end if;
         Odd := not Odd;
      end loop;
      return (Sum mod 10) = 0;
   end Luhn_Test;

   subtype Decimal   is Character range '0' .. '9';
   subtype Letter    is Character range 'A' .. 'Z';
   subtype ISIN_Type is String(1..12);

   -- converts a string of decimals and letters into a string of decimals
   function To_Digits(S: String) return String is
      -- Character'Pos('A')-Offset=10, Character'Pos('B')-Offset=11, ...
      Offset: constant Integer := Character'Pos('A')-10;

      Invalid_Character: exception;
   begin
      if S = "" then
         return "";
      elsif S(S'First) = ' ' then -- skip blanks
         return To_Digits(S(S'First+1 .. S'Last));
      elsif S(S'First) in Decimal then
         return S(S'First) & To_Digits(S(S'First+1 .. S'Last));
      elsif S(S'First) in Letter then
         return To_Digits(Integer'Image(Character'Pos(S(S'First))-Offset))
           & To_Digits(S(S'First+1 .. S'Last));
      else
         raise Invalid_Character;
      end if;
   end To_Digits;

   function Is_Valid_ISIN(S: ISIN_Type) return Boolean is
      Number : String := To_Digits(S);
   begin
      return S(S'First)   in Letter  and
             S(S'First+1) in Letter  and
             S(S'Last)    in Decimal and
             Luhn_Test(Number);
   end Is_Valid_ISIN;

   Test_Cases : constant Array(1..6) of ISIN_Type :=
      ("US0378331005",
       "US0373831005",
       "U50378331005",
       -- excluded by type with fixed length
       -- "US03378331005",
       "AU0000XVGZA3",
       "AU0000VXGZA3",
       "FR0000988040");
begin
   for I in Test_Cases'Range loop
      Ada.Text_IO.Put_Line(Test_Cases(I) & ":" &
        Boolean'Image(Is_Valid_ISIN(Test_Cases(I))));
   end loop;
   -- using wrong length will result in an exception:
   Ada.Text_IO.Put("US03378331005:");
   Ada.Text_IO.Put_Line(Boolean'Image(Is_Valid_Isin("US03378331005")));
exception
   when others =>
      Ada.Text_IO.Put_Line("Exception occured");
end ISIN;
