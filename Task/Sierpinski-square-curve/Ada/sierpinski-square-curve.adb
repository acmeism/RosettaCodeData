with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;                       use Ada.Text_IO;
with Ada.Strings.Unbounded;             use Ada.Strings.Unbounded;
procedure Sierpinski_Square_Curve is
   Axiom    : constant String := "F+XF+F+XF";
   Rules    : constant String := "XF-F+F-XF+F+XF-F+F-X";
   ORDER    : constant Positive := 5;
   LENGTH   : constant Positive := 4;
   X        : Integer := (600 - LENGTH) / 2;
   Y        : Integer := LENGTH;
   Angle    : Integer := 0;
   SVG_File : File_Type;
   Production : Unbounded_String := To_Unbounded_String (Axiom);
   function Rewrite (Str : String) return Unbounded_String is
      Prod : Unbounded_String;
   begin
      for C of Str loop
         if C = 'X' then
            Prod := Prod & Rules;
         else
            Prod := Prod & C;
         end if;
      end loop;
      return Prod;
   end Rewrite;
begin
   Create (SVG_File, Out_File, "sierpinski.svg");
   Put_Line (SVG_File, "<svg xmlns='http://www.w3.org/2000/svg' width='600' height='600'>");
   Put_Line (SVG_File, "<rect width='100%' height='100%' fill='white'/>");
   Put      (SVG_File, "<path stroke-width='1' stroke='black' fill='none' d='M" &
                        X'Image & "," & Y'Image & " ");
   for I in 1 .. ORDER loop
      Production := Rewrite (To_String (Production));
   end loop;
   for C of To_String (Production) loop
      case C is
         when 'F' =>
            X := X + LENGTH * Integer (Cos (Float (Angle), 360.0));
            Y := Y + LENGTH * Integer (Sin (Float (Angle), 360.0));
            Put (SVG_File, " L" & X'Image & "," & Y'Image);
         when '+' => Angle := (Angle + 90) mod 360;
         when '-' => Angle := (Angle - 90) mod 360;
         when others => null;
      end case;
   end loop;
   Put_Line (SVG_File, "'/>\n</svg>");
   Close (SVG_File);
end Sierpinski_Square_Curve;
