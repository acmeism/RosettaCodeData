with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Fixed;        use Ada.Strings;
with Ada.Strings.Unbounded;

procedure De_Bruijn_Sequences is

   function De_Bruijn (K, N : Positive) return String
   is
      use Ada.Strings.Unbounded;

      Alphabet : constant String := "0123456789";

      subtype Decimal is Integer range 0 .. 9;
      type Decimal_Array is array (Natural range <>) of Decimal;

      A   : Decimal_Array (0 .. K * N - 1) := (others => 0);
      Seq : Unbounded_String;

      procedure Db (T, P : Positive) is
      begin
         if T > N then
            if N mod P = 0 then
               for E of A (1 .. P) loop
                  Append (Seq, Alphabet (Alphabet'First + E));
               end loop;
            end if;
         else
            A (T) := A (T - P);
            Db (T + 1, P);
            for J in A (T - P) + 1 .. K - 1 loop
               A (T) := J;
               Db (T + 1, T);
            end loop;
         end if;
      end Db;

   begin
      Db (1, 1);
      return To_String (Seq) & Slice (Seq, 1, N - 1);
   end De_Bruijn;

   function Image (Value : Integer) return String
   is (Fixed.Trim (Value'Image, Left));

   function PIN_Image (Value : Integer) return String
   is (Fixed.Tail (Image (Value), Count => 4, Pad => '0'));

   procedure Validate (Db : String)
   is
      Found  : array (0 .. 9_999) of Natural := (others => 0);
      Errors : Natural := 0;
   begin

      --  Check all strings of 4 consecutive digits within 'db'
      --  to see if all 10,000 combinations occur without duplication.
      for A in Db'First .. Db'Last - 3 loop
         declare
            PIN : String renames Db (A .. A + 4 - 1);
         begin
            if (for all Char of PIN => Char in '0' .. '9') then
               declare
                  N : constant Integer := Integer'Value (PIN);
                  F : Natural renames Found (N);
               begin
                  F := F + 1;
               end;
            end if;
         end;
      end loop;

      for I in 0_000 .. 9_999 loop
         if Found (I) = 0 then
            Put_Line ("  PIN number " & PIN_Image (I) & " missing");
            Errors := Errors + 1;
         elsif Found (I) > 1 then
            Put_Line ("  PIN number " & PIN_Image (I) & " occurs "
                        & Image (Found (I)) & " times");
            Errors := Errors + 1;
         end if;
      end loop;

      case Errors is
         when 0 =>  Put_Line ("  No errors found");
         when 1 =>  Put_Line ("  1 error found");
         when others =>
            Put_Line ("  " & Image (Errors) & " errors found");
      end case;
   end Validate;

   function Backwards (S : String) return String is
      R : String (S'Range);
   begin
      for A in 0 .. S'Length - 1 loop
         R (R'Last - A) := S (S'First + A);
      end loop;
      return R;
   end Backwards;

   DB  : constant String := De_Bruijn (K => 10, N => 4);
   Rev : constant String := Backwards (DB);
   Ovl :          String := DB;
begin
   Put_Line ("The length of the de Bruijn sequence is " & DB'Length'Image);
   New_Line;

   Put_Line ("The first 130 digits of the de Bruijn sequence are: ");
   Put_Line ("  " & Fixed.Head (DB, 130));
   New_Line;

   Put_Line ("The last 130 digits of the de Bruijn sequence are: ");
   Put_Line ("  " & Fixed.Tail (DB, 130));
   New_Line;

   Put_Line ("Validating the deBruijn sequence:");
   Validate (DB);
   New_Line;

   Put_Line ("Validating the reversed deBruijn sequence:");
   Validate (Rev);
   New_Line;

   Ovl (4444) := '.';
   Put_Line ("Validating the overlaid deBruijn sequence:");
   Validate (Ovl);
   New_Line;
end De_Bruijn_Sequences;
