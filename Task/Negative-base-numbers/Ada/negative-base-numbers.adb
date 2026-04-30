with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Negative_Base_Numbers is

   subtype base_t is Long_Long_Integer range -62 .. -1;

   function Encode_Negative_Base
     (N : in Long_Long_Integer; Base : in base_t) return Unbounded_String;
   function Decode_Negative_Base
     (N : in Unbounded_String; Base : in base_t) return Long_Long_Integer;

end Negative_Base_Numbers;

with Ada.Text_IO;
package body Negative_Base_Numbers is

   Digit_Chars : constant String :=
     "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

   --------------------------
   -- Encode_Negative_Base --
   --------------------------

   function Encode_Negative_Base
     (N : in Long_Long_Integer; Base : in base_t) return Unbounded_String
   is
      procedure swap (a, b : in out Character) is
         temp : Character := a;
      begin
         a := b;
         b := temp;
      end swap;

      Result    : Unbounded_String  := Null_Unbounded_String;
      Local_N   : Long_Long_Integer := N;
      Remainder : Long_Long_Integer;

   begin
      if Local_N = 0 then
         Result := To_Unbounded_String ("0");
      else
         while Local_N /= 0 loop
            Remainder := Local_N rem Base;
            Local_N   := Local_N / Base;
            if Remainder < 0 then
               Local_N   := Local_N + 1;
               Remainder := Remainder - Base;
            end if;
            Append (Result, Digit_Chars (Integer (Remainder + 1)));
         end loop;
      end if;

      declare
         Temp_Result : String   := To_String (Result);
         Low         : Positive := Temp_Result'First;
         High        : Positive := Temp_Result'Last;
      begin
         while Low < High loop
            swap (Temp_Result (Low), Temp_Result (High));
            Low  := Low + 1;
            High := High - 1;
         end loop;
         Result := To_Unbounded_String (Temp_Result);
      end;

      return Result;
   end Encode_Negative_Base;

   --------------------------
   -- Decode_Negative_Base --
   --------------------------

   function Decode_Negative_Base
     (N : in Unbounded_String; Base : in base_t) return Long_Long_Integer
   is
      Total : Long_Long_Integer := 0;
      bb    : Long_Long_Integer := 1;
      Temp  : String            := To_String (N);
   begin
      if Length (N) = 0 or else (Length (N) = 1 and Element (N, 1) = '0') then
         return 0;
      end if;

      for char of reverse Temp loop
         for J in Digit_Chars'Range loop
            if char = Digit_Chars (J) then
               Total := Total + Long_Long_Integer (J - 1) * bb;
               bb    := bb * Base;
            end if;
         end loop;
      end loop;

      return Total;
   end Decode_Negative_Base;

end Negative_Base_Numbers;

with Ada.Text_IO;           use Ada.Text_IO;
with Negative_Base_Numbers; use Negative_Base_Numbers;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is

   procedure driver (N : in Long_Long_Integer; B : in base_t) is
      package long_IO is new Integer_IO (Long_Long_Integer);
      use long_IO;

      ns     : Unbounded_String := Encode_Negative_Base (N, B);
      P      : Long_Long_Integer;
      Output : String (1 .. 12);

   begin
      Put (Item => N, Width => 12);
      Put (" encoded in base ");
      Put (Item => B, Width => 3);
      Put_Line (" = " & To_String (ns));

      Move
        (Source  => To_String (ns), Target => Output,
         Justify => Ada.Strings.Right);
      P := Decode_Negative_Base (ns, B);
      Put (Output & " decoded in base ");
      Put (Item => B, Width => 3);
      Put (" = ");
      Put (Item => P, Width => 1);
      New_Line (2);
   end driver;

begin
   driver (10, -2);
   driver (146, -3);
   driver (15, -10);
   driver (36_058, -62);
end Main;
