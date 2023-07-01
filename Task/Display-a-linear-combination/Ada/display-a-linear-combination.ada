with Ada.Text_Io;
with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

procedure Display_Linear is

   subtype Position is Positive;
   type Coefficient is new Integer;
   type Combination is array (Position range <>) of Coefficient;

   function Linear_Combination (Comb : Combination) return String is
      use Ada.Strings.Unbounded;
      use Ada.Strings;
      Accu : Unbounded_String;
   begin
      for Pos in Comb'Range loop
         case Comb (Pos) is
            when Coefficient'First .. -1 =>
               Append (Accu, (if Accu = "" then "-" else " - "));
            when 0 => null;
            when 1 .. Coefficient'Last =>
               Append (Accu, (if Accu /= "" then " + " else ""));
         end case;

         if Comb (Pos) /= 0 then
            declare
               Abs_Coeff   : constant Coefficient := abs Comb (Pos);
               Coeff_Image : constant String := Fixed.Trim (Coefficient'Image (Abs_Coeff), Left);
               Exp_Image   : constant String := Fixed.Trim (Position'Image (Pos), Left);
            begin
               if Abs_Coeff /= 1 then
                  Append (Accu, Coeff_Image & "*");
               end if;
               Append (Accu, "e(" & Exp_Image & ")");
            end;
         end if;
      end loop;

      return (if Accu = "" then "0" else To_String (Accu));
   end Linear_Combination;

   use Ada.Text_Io;
begin
   Put_Line (Linear_Combination ((1, 2, 3)));
   Put_Line (Linear_Combination ((0, 1, 2, 3)));
   Put_Line (Linear_Combination ((1, 0, 3, 4)));
   Put_Line (Linear_Combination ((1, 2, 0)));
   Put_Line (Linear_Combination ((0, 0, 0)));
   Put_Line (Linear_Combination ((1 => 0)));
   Put_Line (Linear_Combination ((1, 1, 1)));
   Put_Line (Linear_Combination ((-1, -1, -1)));
   Put_Line (Linear_Combination ((-1, -2, 0, -3)));
   Put_Line (Linear_Combination ((1 => -1)));
end Display_Linear;
