with PDF_Out;  use PDF_Out;

procedure Peano_Curve is

   Filename   : constant String     := "peano-curve.pdf";
   Order      : constant Positive   := 4;
   Scale      : constant Real       := 2.1;
   Line_Width : constant Real       := 2.5;
   Corner     : constant Point      := (150.0, 50.0);
   Background : constant Color_Type := (0.827, 0.816, 0.016);
   Frame      : constant Rectangle  := (10.0, 10.0, 820.0, 575.0);
   PDF        : PDF_Out_File;

   type Coord is record
      X, Y : Natural;
   end record;

   function "+" (Left : Coord; Right : Coord) return Coord
   is ((Left.X + Right.X, Left.Y + Right.Y));

   function "*" (Left : Natural; Right : Coord) return Coord
   is ((Left * Right.X, Left * Right.Y));

   procedure Peano (Pos : Coord; Length : Positive; I1, I2 : Integer) is
      Len : constant Integer := Length / 3;
   begin
      if Length = 1 then
         PDF.Line (Corner + Scale * (Real (3 * Pos.X), Real (3 * Pos.Y)));
      else
         Peano (Pos + Len * (2 * I1,      2 * I1),      Len, I1,     I2);
         Peano (Pos + Len * (I1 - I2 + 1, I1 + I2),     Len, I1,     1 - I2);
         Peano (Pos + Len * (1,           1),           Len, I1,     1 - I2);
         Peano (Pos + Len * (I1 + I2,     I1 - I2 + 1), Len, 1 - I1, 1 - I2);
         Peano (Pos + Len * (2 * I2,      2 - 2 * I2),  Len, I1,     I2);
         Peano (Pos + Len * (1 + I2 - I1, 2 - I1 - I2), Len, I1,     I2);
         Peano (Pos + Len * (2 - 2 * I1,  2 - 2 * I1),  Len, I1,     I2);
         Peano (Pos + Len * (2 - I1 - I2, 1 + I2 - I1), Len, 1 - I1, I2);
         Peano (Pos + Len * (2 - 2 * I2,  2 * I2),      Len, 1 - I1, I2);
      end if;
   end Peano;

   procedure Draw_Peano is
   begin
      PDF.Stroking_Color (Black);
      PDF.Line_Width (Line_Width);
      PDF.Move (Corner);
      Peano ((0, 0), 3**Order, 0, 0);
      PDF.Finish_Path (Close_Path => False,
                       Rendering  => Stroke,
                       Rule       => Nonzero_Winding_Number);
   end Draw_Peano;

begin
   PDF.Create (Filename);
   PDF.Page_Setup (A4_Landscape);

   PDF.Color (Background);
   PDF.Draw (Frame, Fill);

   Draw_Peano;
   PDF.Close;
end Peano_Curve;
