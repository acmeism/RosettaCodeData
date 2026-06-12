with Ada.Text_IO;           use Ada.Text_IO;
with Unbounded_Rationals;   use Unbounded_Rationals;

with Generic_Map;
with Strings_Edit.UTF8.Superscript.Integer_Edit;
with Strings_Edit.Unbounded_Integer_Edit;
with Strings_Edit.Unbounded_Rational_Edit;
with Unbounded_Integers;
with Tables;

procedure Unicode_Polynomial_Equation is
   package Fraction_Tables is new Tables (Unbounded_Rational);
   use Fraction_Tables;
   use Strings_Edit.Unbounded_Rational_Edit;
   use Strings_Edit;

   Fractions : Fraction_Tables.Table;
   Mul_1     : constant String := Strings_Edit.UTF8.Image (16#00D7#);
   Mul_2     : constant String := Strings_Edit.UTF8.Image (16#00B7#);
   Mul_3     : constant String := Strings_Edit.UTF8.Image (16#22C5#);
   Div_1     : constant String := Strings_Edit.UTF8.Image (16#2215#);
   Div_2     : constant String := Strings_Edit.UTF8.Image (16#2044#);
   S_Minus   : constant String := Strings_Edit.UTF8.Image (16#207B#);
   S_Plus    : constant String := Strings_Edit.UTF8.Image (16#207A#);
   Exp_1     : constant String := Strings_Edit.UTF8.Image (16#23E8#);
   Exp_2     : constant String := Strings_Edit.UTF8.Image (16#2191#);

   Ten : constant Unbounded_Rational := To_Unbounded_Rational (10);

   type Power is new Integer;
   package Superscript_Integers is
      new Strings_Edit.UTF8.Superscript.Integer_Edit (Power);
   use Superscript_Integers;

   package Power_To_Coefficients is
      new Generic_Map (Power, Unbounded_Rational);
   subtype Polynome is Power_To_Coefficients.Map;

   procedure Append
             (  Value       : in out Polynome;
                Exponent    : Power;
                Coefficient : Unbounded_Rational
             )  is
      I : Integer;
   begin
      I := Value.Find (Exponent);
      if I > 0 then
         Value.Replace (I, Value.Get (I) + Coefficient);
      else
         Value.Add (Exponent, Coefficient);
      end if;
   end Append;

   procedure Print (X : Polynome) is
      Coefficient : Unbounded_Rational;

      procedure Put is
         use Unbounded_Integers;
         use Strings_Edit.Unbounded_Integer_Edit;
         Fraction : Unbounded_Rational;
         Value    : Unbounded_Integer;
      begin
         Split (Coefficient, Value, Fraction);
         if not Is_Zero (Fraction) then
            for I in 1..Fractions.GetSize loop
               if Fractions.GetTag (I) = Fraction then
                  if not Is_Zero (Value) then
                     Put (Image (Value));
                  end if;
                  Put (Fractions.GetName (I));
                  return;
               end if;
            end loop;
         end if;
         Put (Image_Recurring (Coefficient));
      end Put;

      Exponent : Power;
      First    : Boolean := True;
   begin
      for I in reverse 1..X.Get_Size loop
         Exponent    := X.Get_Key (I);
         Coefficient := X.Get (I);
         if not Is_Zero (Coefficient) then
            if Is_Negative (Coefficient) then
               if First then
                  Put ("-");
                  First := False;
               else
                  Put (" - ");
               end if;
               Coefficient := -Coefficient;
            else
               if First then
                  First := False;
               else
                  Put (" + ");
               end if;
            end if;
            if Is_One (Coefficient) then
               case Exponent is
                  when 0 =>
                     Put ("1");
                  when 1 =>
                     Put ("x");
                  when others =>
                     Put ('x' & Image (Exponent));
               end case;
            else
               Put;
               case Exponent is
                  when 0 =>
                     null;
                  when 1 =>
                     Put ("x");
                  when others =>
                     Put ('x' & Image (Exponent));
               end case;
            end if;
         end if;
      end loop;
      if First then
         Put ("0");
      end if;
   end Print;

   procedure Get_Natural
             (  Line    : String;
                Pointer : in out Integer;
                Value   : out Unbounded_Rational;
                Width   : out Natural
             )  is
   begin
      Width := 0;
      Value := Zero;
      while Pointer <= Line'Last loop
         case Line (Pointer) is
            when '0'..'9' =>
               Value := Value * 10 + Character'Pos (Line (Pointer))
                                   - Character'Pos ('0');
               Width := Width + 1;
            when  ',' =>
               null;
            when others =>
               exit;
         end case;
         Pointer := Pointer + 1;
      end loop;
   end Get_Natural;

   procedure Get_Power
             (  Line    : String;
                Pointer : in out Integer;
                Value   : out Power;
                Default : Power := 0
             )  is
      Width   : Natural  := 1;
      Sign    : Power    := 1;
      Got_It  : Boolean := True;
      X       : Unbounded_Rational := One;
   begin
      Got_It := True;
      if Is_Prefix (Exp_1, Line, Pointer) then
         Pointer := Pointer + Exp_1'Length;
      elsif Is_Prefix (Exp_2, Line, Pointer) then
         Pointer := Pointer + Exp_2'Length;
      elsif Is_Prefix ("**", Line, Pointer) then
         Pointer := Pointer + 2;
      elsif Pointer <= Line'Last and then
            Line (Pointer) in '^' | 'e' | 'E' then
         Pointer := Pointer + 1;
      else
         Got_It := False;
         begin
            loop
               if Is_Prefix (S_Plus, Line, Pointer) then
                  Pointer := Pointer + S_Plus'Length;
                  Got_It  := True;
               elsif Is_Prefix (S_Minus, Line, Pointer) then
                  Pointer := Pointer + S_Minus'Length;
                  Got_It  := True;
                  Sign    := -Sign;
               else
                  exit;
               end if;
            end loop;
            Get (Line, Pointer, Value);
            Value := Value * Sign;
         exception
            when End_Error =>
               if Got_It then
                  raise Data_Error with "Missing exponent " &
                                        Line (Pointer..Line'Last);
               end if;
               Value := Default;
            when others =>
               raise Data_Error with "Invalid exponent " &
                                     Line (Pointer..Line'Last);
         end;
         return;
      end if;
      while Pointer <= Line'Last loop
         if Line (Pointer) = '+' then
            Pointer := Pointer + 1;
         elsif Line (Pointer) = '-' then
            Pointer := Pointer + 1;
            Sign := -Sign;
         else
            exit;
         end if;
      end loop;
      Get_Natural (Line, Pointer, X, Width);
      if Width = 0 then
         raise Data_Error with "Missing exponent " &
                               Line (Pointer..Line'Last);
      end if;
      Value := Sign * Power (To_Integer (X));
   end Get_Power;

   procedure Get_Number
             (  Line     : String;
                Pointer  : in out Integer;
                Value    : out Unbounded_Rational;
                Got_It   : out Boolean
             )  is
      Width    : Natural;
      X        : Unbounded_Rational := One;
      Exponent : Power;
   begin
      Get (Line, Pointer, Fractions, Value, Got_It);
      if not Got_It then
         Get_Natural (Line, Pointer, Value, Width);
         Got_It := Width > 0;
         if Pointer <= Line'Last and then Line (Pointer) = '.' then
            Pointer := Pointer + 1;
            Get_Natural (Line, Pointer, X, Width);
            Value := Value + X / Ten ** Width;
            if Width = 0 and not Got_It then
               raise Data_Error with
                     "Single dot where number expected " &
                     Line (Pointer..Line'Last);
            end if;
            Got_It := True;
         end if;
         if Got_It then
            Get (Line, Pointer, Fractions, X, Got_It);
            if Got_It then
               Value := Value + X;
            else
               Got_It := True;
            end if;
         end if;
      end if;
      if not Got_It then
         return;
      end if;
      Get_Power (Line, Pointer, Exponent);
      Value := Value * Ten ** Integer (Exponent);
   end Get_Number;

   procedure Get_Variable
             (  Line     : String;
                Pointer  : in out Integer;
                Value    : out Power;
                Expected : Boolean := True
             )  is
   begin
      if Pointer <= Line'Last and then Line (Pointer) in 'x' then
         Pointer := Pointer + 1;
         Get_Power (Line, Pointer, Value, 1);
      elsif Expected then
         raise Data_Error with "x is expected " &
                               Line (Pointer..Line'Last);
      else
         Value := 0;
      end if;
   end Get_Variable;

   procedure Get_Term
             (  Line     : String;
                Pointer  : in out Integer;
                Value    : in out Polynome;
                Negative : Boolean
             )  is
      Coefficient : Unbounded_Rational;
      Exponent    : Power := 0;
      Got_It      : Boolean;

      procedure Get_Divisor is
         Divisor : Unbounded_Rational;
      begin
         Get_Number (Line, Pointer, Divisor, Got_It);
         if not Got_It then
            raise Data_Error with "Missing divisor " &
                                  Line (Pointer..Line'Last);
         end if;
         Coefficient := Coefficient / Divisor;
      end Get_Divisor;
   begin
      Get_Number (Line, Pointer, Coefficient, Got_It);
      if Got_It then
         if Is_Prefix (Mul_1, Line, Pointer) then
            Pointer := Pointer + Mul_1'Length;
            Get_Variable (Line, Pointer, Exponent);
         elsif Is_Prefix (Mul_2, Line, Pointer) then
            Pointer := Pointer + Mul_2'Length;
            Get_Variable (Line, Pointer, Exponent);
         elsif Is_Prefix (Mul_3, Line, Pointer) then
            Pointer := Pointer + Mul_3'Length;
            Get_Variable (Line, Pointer, Exponent);
         elsif Is_Prefix (Div_1 & 'x', Line, Pointer) then
            Pointer  := Pointer + Div_1'Length + 1;
            Get_Power (Line, Pointer, Exponent, 1);
            Exponent := -Exponent;
         elsif Is_Prefix (Div_2 & 'x', Line, Pointer) then
            Pointer  := Pointer + Div_2'Length + 1;
            Get_Power (Line, Pointer, Exponent, 1);
            Exponent := -Exponent;
         elsif Is_Prefix ("/x", Line, Pointer) then
            Pointer  := Pointer + 2;
            Get_Power (Line, Pointer, Exponent, 1);
            Exponent := -Exponent;
         else
            Get_Variable (Line, Pointer, Exponent, False);
         end if;
      else
         Coefficient := One;
         Get_Variable (Line, Pointer, Exponent, True);
      end if;
      if Negative then
         Coefficient := -Coefficient;
      end if;
      if Is_Prefix (Div_1, Line, Pointer) then
         Pointer := Pointer + Div_1'Length;
         Get_Divisor;
      elsif Is_Prefix (Div_2, Line, Pointer) then
         Pointer := Pointer + Div_2'Length;
         Get_Divisor;
      elsif Is_Prefix ("/", Line, Pointer) then
         Pointer := Pointer + 1;
         Get_Divisor;
      end if;
      Append (Value, Exponent, Coefficient);
   end Get_Term;

   procedure Get_Polynome
             (  Line    : String;
                Pointer : in out Integer;
                Value   : in out Polynome
             )  is
      Negative : Boolean := False;
   begin
      loop
         loop
            exit when Pointer > Line'Last;
            case Line (Pointer) is
               when '-' =>
                  Negative := not Negative;
                  Pointer  := Pointer + 1;
               when '+' => null;
                  Pointer  := Pointer + 1;
               when others =>
                  exit;
            end case;
         end loop;
         Get_Term (Line, Pointer, Value, Negative);
         exit when Pointer > Line'Last;
         case Line (Pointer) is
            when '-' =>
               Negative := True;
               Pointer  := Pointer + 1;
            when '+' => null;
               Negative := False;
               Pointer  := Pointer + 1;
            when others =>
               exit;
         end case;
      end loop;
   end Get_Polynome;

   procedure Check (Text : String) is
      Line    : String (1..Text'Last);
      Pointer : Integer := 1;
      To      : Integer := Line'First;
      Result  : Polynome;
   begin
      Put (Text);
      for From in Text'Range loop
         if Text (From) /= ' ' then
            Line (To) := Text (From);
            To := To + 1;
         end if;
      end loop;
      Get_Polynome (Line (Pointer..To - 1), Pointer, Result);
      if Pointer < To then
         raise Data_Error with "Unrecognized " &
                               Line (Pointer..To - 1);
      end if;
      Put (" = "); Print (Result); New_Line;
   end Check;

begin
   Fractions.Add (Strings_Edit.UTF8.Image (16#BC#), One/4);
   Fractions.Add (Strings_Edit.UTF8.Image (16#BD#), One/2);
   Fractions.Add (Strings_Edit.UTF8.Image (16#BE#), Three/4);
   Fractions.Add (Strings_Edit.UTF8.Image (8528),   One/7);
   Fractions.Add (Strings_Edit.UTF8.Image (8529),   One/9);
   Fractions.Add (Strings_Edit.UTF8.Image (8530),   One/10);
   Fractions.Add (Strings_Edit.UTF8.Image (8531),   One/3);
   Fractions.Add (Strings_Edit.UTF8.Image (8532),   Two/3);
   Fractions.Add (Strings_Edit.UTF8.Image (8533),   One/5);
   Fractions.Add (Strings_Edit.UTF8.Image (8534),   Two/5);
   Fractions.Add (Strings_Edit.UTF8.Image (8535),   Three/5);
   Fractions.Add (Strings_Edit.UTF8.Image (8536),   Four/5);
   Fractions.Add (Strings_Edit.UTF8.Image (8537),   One/6);
   Fractions.Add (Strings_Edit.UTF8.Image (8538),   Five/6);
   Fractions.Add (Strings_Edit.UTF8.Image (8539),   One/8);
   Fractions.Add (Strings_Edit.UTF8.Image (8540),   Three/8);
   Fractions.Add (Strings_Edit.UTF8.Image (8541),   Five/8);
   Fractions.Add (Strings_Edit.UTF8.Image (8542),   (Five + 2)/6);
   Fractions.Add (Strings_Edit.UTF8.Image (8585),   Zero/1);

   Check ("1");
   Check ("x");
   Check ("4x³");
   Check ("1x⁵ - 2x⁴ + 42x³ + 0x² + 40x + 1");
   Check ("0e+0x⁰⁰⁷ + 00e-00x + 0x + .0x⁰⁵ - 0.x⁴ + 0×x³ + 0x⁻⁰ + 0/x + 0/x³ + 0x⁻⁵");
   Check ("1x⁵ - 2x⁴ + 42x³ + 40x + 1x⁰");
   Check ("+x⁺⁵ + -2x⁻⁻⁴ + 42x⁺⁺³ + +40x - -1");
   Check ("x^5 - 2x**4 + 42x^3 + 40x + 1");
   Check ("x↑5 - 2.00·x⁴ + 42.00·x³ + 40.00·x + 1");
   Check ("x⁻⁵ - 2⁄x⁴ + 42x⁻³ + 40/x + 1x⁻⁰");
   Check ("x⁵ - 2x⁴ + 42.000 000x³ + 40x");
   Check ("x⁵ - 2x⁴ + 0,042x³ + 40.000,000x + 1");
   Check ("0x⁷ + 10x + 10x + x⁵ - 2x⁴ + 42x³ + 20x + 1");
   Check ("1E0x⁵ - 2,000,000.e-6x⁴ + 4.2⏨1x³ + .40e+2x + 1");
   Check ("x⁵ - x⁴⁄2 + 405x³⁄4 + 403x⁄4 + 5⁄2");
   Check ("x⁵ - ½x⁴ + 101¼x³ + 100¾x + 2½");
end Unicode_Polynomial_Equation;
