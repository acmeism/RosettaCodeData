package body Long_Multiplication is
   function Value (Item : in String) return Number is
      subtype Base_Ten_Digit is Digit range 0 .. 9;
      Ten : constant Number := (0 => 10);
   begin
      case Item'Length is
         when 0 =>
            raise Constraint_Error;
         when 1 =>
            return (0 => Base_Ten_Digit'Value (Item));
         when others =>
            return (0 => Base_Ten_Digit'Value (Item (Item'Last .. Item'Last)))
              + Ten * Value (Item (Item'First .. Item'Last - 1));
      end case;
   end Value;

   function Image (Item : in Number) return String is
      Base_Ten  : constant array (Digit range 0 .. 9) of String (1 .. 1) :=
                    ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
      Result    : Number (0 .. Item'Last);
      Remainder : Digit;
   begin
      if Item = Zero then
         return "0";
      else
         Divide (Dividend  => Item,
                 Divisor   => 10,
                 Result    => Result,
                 Remainder => Remainder);

         if Result = Zero then
            return Base_Ten (Remainder);
         else
            return Image (Trim (Result)) & Base_Ten (Remainder);
         end if;
      end if;
   end Image;

   overriding
   function "=" (Left, Right : in Number) return Boolean is
   begin
      for Position in Integer'Min (Left'First, Right'First) ..
                      Integer'Max (Left'Last,  Right'Last) loop
         if Position in Left'Range and Position in Right'Range then
            if Left (Position) /= Right (Position) then
               return False;
            end if;
         elsif Position in Left'Range then
            if Left (Position) /= 0 then
               return False;
            end if;
         elsif Position in Right'Range then
            if Right (Position) /= 0 then
               return False;
            end if;
         else
            raise Program_Error;
         end if;
      end loop;

      return True;
   end "=";

   function "+" (Left, Right : in Number) return Number is
      Result      : Number (Integer'Min (Left'First, Right'First) ..
                            Integer'Max (Left'Last , Right'Last) + 1);
      Accumulator : Accumulated_Value := 0;
      Used        : Integer := Integer'First;
   begin
      for Position in Result'Range loop
         if Position in Left'Range then
            Accumulator := Accumulator + Left (Position);
         end if;

         if Position in Right'Range then
            Accumulator := Accumulator + Right (Position);
         end if;

         Result (Position) := Accumulator mod Base;
         Accumulator := Accumulator / Base;

         if Result (Position) /= 0 then
            Used := Position;
         end if;
      end loop;

      if Accumulator = 0 then
         return Result (Result'First .. Used);
      else
         raise Constraint_Error;
      end if;
   end "+";

   function "*" (Left, Right : in Number) return Number is
      Accumulator : Accumulated_Value;
      Result      : Number (Left'First + Right'First ..
                            Left'Last  + Right'Last + 1) := (others => 0);
      Used        : Integer := Integer'First;
   begin
      for L in Left'Range loop
         for R in Right'Range loop
            Accumulator := Left (L) * Right (R);

            for Position in L + R .. Result'Last loop
               exit when Accumulator = 0;

               Accumulator := Accumulator + Result (Position);
               Result (Position) := Accumulator mod Base;
               Accumulator := Accumulator / Base;
               Used := Position;
            end loop;
         end loop;
      end loop;

      return Result (Result'First .. Used);
   end "*";

   procedure Divide (Dividend  : in     Number;
                     Divisor   : in     Digit;
                     Result    :    out Number;
                     Remainder :    out Digit) is
      Accumulator : Accumulated_Value := 0;
   begin
      Result := (others => 0);

      for Position in reverse Dividend'Range loop
         Accumulator := Accumulator * Base + Dividend (Position);
         Result (Position) := Accumulator / Divisor;
         Accumulator := Accumulator mod Divisor;
      end loop;

      Remainder := Accumulator;
   end Divide;

   function Trim (Item : in Number) return Number is
   begin
      for Position in reverse Item'Range loop
         if Item (Position) /= 0 then
            return Item (Item'First .. Position);
         end if;
      end loop;

      return Zero;
   end Trim;
end Long_Multiplication;
