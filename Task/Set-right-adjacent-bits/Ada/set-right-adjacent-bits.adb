with Ada.Text_IO;

procedure Set_Right_Bits is

   type Bit_Number is new Positive range 1 .. 10_000;
   type Bit        is new Boolean;
   type Bit_Collection is array (Bit_Number range <>) of Bit
     with Pack;

   function Right_Adjacent (B : Bit_Collection;
                            N : Natural) return Bit_Collection
   is
      Result : Bit_Collection := B;
      Mask   : Bit_Collection := B;
   begin
      for A in 1 .. N loop
         Mask   := False & Mask (Mask'First .. Mask'Last - 1);
         --  Shift Mask by appending False/0 in front of slice.

         Result := Result or Mask;
      end loop;
      return Result;
   end Right_Adjacent;

   procedure Put (Collection : Bit_Collection) is
      use Ada.Text_IO;
   begin
      for Bit of Collection loop
         Put ((if Bit then '1' else '0'));
      end loop;
   end Put;

   function Value (Item : String) return Bit_Collection
   is
      Length : constant Bit_Number := Item'Length;
      Result : Bit_Collection (1 .. Length);
      Index  : Natural := Item'First;
   begin
      for R of Result loop
         R := (case Item (Index) is
                  when '0' | 'F' | 'f' => False,
                  when '1' | 'T' | 't' => True,
                  when others =>
                     raise Constraint_Error with "invalid input");
         Index := Index + 1;
      end loop;
      return Result;
   end Value;

   procedure Show (Bit_String : String; N : Natural)
   is
      B      : constant Bit_Collection := Value (Bit_String);
      R      : constant Bit_Collection := Right_Adjacent (B, N);
      Prefix : constant String         := "        ";
      use Ada.Text_IO;
   begin
      Put ("n =");          Put (N'Image);
      Put ("; Width e =");  Put (Bit_String'Length'Image);
      Put (":");            New_Line;
      Put (Prefix);  Put ("Input B: ");  Put (B);  New_Line;
      Put (Prefix);  Put ("Result : ");  Put (R);  New_Line;
      New_Line;
   end Show;

begin
   Show ("1000", 2);
   Show ("0100", 2);
   Show ("0010", 2);
   Show ("0000", 2);

   Show ("010000000000100000000010000000010000000100000010000010000100010010", 0);
   Show ("010000000000100000000010000000010000000100000010000010000100010010", 1);
   Show ("010000000000100000000010000000010000000100000010000010000100010010", 2);
   Show ("010000000000100000000010000000010000000100000010000010000100010010", 3);
end Set_Right_Bits;
