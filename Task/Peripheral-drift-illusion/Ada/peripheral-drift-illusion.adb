with PDF_Out;  use PDF_Out;

procedure Drift is

   X_Distance : constant := 30.0;
   Y_Distance : constant := 30.0;
   X_Length   : constant := 20.0;
   Y_Length   : constant := 20.0;
   Edge_Width : constant :=  1.5;
   Corner     : constant Point := (220.0, 140.0);

   type Edge_Kind   is (Top, Right, Bottom, Left);
   type Square_Kind is (Left_Top, Top_Right, Right_Bottom, Bottom_Left);
   --  Signifies the white edges on the blue squares

   LT : constant Square_Kind := Left_Top;
   TR : constant Square_Kind := Top_Right;
   RB : constant Square_Kind := Right_Bottom;
   BL : constant Square_Kind := Bottom_Left;

   type X_Index is range 0 .. 11;
   type Y_Index is range 0 .. 11;
   Squares : constant array (Y_Index, X_Index) of Square_Kind :=
     (11 => (LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB),
      10 => (LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL),
      09 => (TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL),
      08 => (TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT),
      07 => (RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT),
      06 => (RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR),
      05 => (BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR),
      04 => (BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB),
      03 => (LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB),
      02 => (LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL),
      01 => (TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL),
      00 => (TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT));
   --  PDF has origo in lower left corner of the paper. Reverse
   --  Y_Index so the program text looks like the output.

   Light_Olive : constant Color_Type := (0.827, 0.816, 0.016);
   Pale_Blue   : constant Color_Type := (0.196, 0.314, 1.000);
   White       : constant Color_Type := (1.000, 1.000, 1.000);

   Colors : constant array (Square_Kind, Edge_Kind) of Color_Type :=
     (Left_Top     => (Top    | Left   => White, others => Black),
      Top_Right    => (Top    | Right  => White, others => Black),
      Right_Bottom => (Right  | Bottom => White, others => Black),
      Bottom_Left  => (Bottom | Left   => White, others => Black));

   PDF : PDF_Out_File;

   procedure Fill_Poly (P1, P2, P3, P4 : Point; Color : Color_Type) is
   begin
      PDF.Color (Color);
      PDF.Move (Corner + P1);
      PDF.Line (Corner + P2);
      PDF.Line (Corner + P3);
      PDF.Line (Corner + P4);
      PDF.Finish_Path (Close_Path => True,
                       Rendering  => Fill,
                       Rule       => Nonzero_Winding_Number);
   end Fill_Poly;

   procedure Draw_Square (Pos : Point; Kind : Square_Kind) is
      Inner_TL : constant Point := Pos + (0.0,      Y_Length);
      Inner_TR : constant Point := Pos + (X_Length, Y_Length);
      Inner_BR : constant Point := Pos + (X_Length, 0.0);
      Inner_BL : constant Point := Pos + (0.0,      0.0);
      Outer_TL : constant Point := Inner_TL + (-Edge_Width,  Edge_Width);
      Outer_TR : constant Point := Inner_TR + (Edge_Width,   Edge_Width);
      Outer_BR : constant Point := Inner_BR + (Edge_Width,  -Edge_Width);
      Outer_BL : constant Point := Inner_BL + (-Edge_Width, -Edge_Width);
   begin
      Fill_Poly (Inner_TL, Inner_TR, Inner_BR, Inner_BL, Pale_Blue);
      Fill_Poly (Inner_TL, Outer_TL, Outer_TR, Inner_TR, Colors (Kind, Top));
      Fill_Poly (Inner_TR, Outer_TR, Outer_BR, Inner_BR, Colors (Kind, Right));
      Fill_Poly (Inner_BR, Outer_BR, Outer_BL, Inner_BL, Colors (Kind, Bottom));
      Fill_Poly (Inner_BL, Outer_BL, Outer_TL, Inner_TL, Colors (Kind, Left));
   end Draw_Square;

   procedure Draw_Squares is
   begin
      for X in Squares'Range (2) loop
         for Y in Squares'Range (1) loop
            Draw_Square (Pos  => (X => Real (X) * X_Distance,
                                  Y => Real (Y) * Y_Distance),
                         Kind => Squares (Y, X));
         end loop;
      end loop;
   end Draw_Squares;

begin
   PDF.Create ("peripheral-drift-illusion.pdf");
   PDF.Page_Setup (A4_Landscape);

   PDF.Color (Light_Olive);
   PDF.Draw ((10.0, 10.0, 820.0, 575.0), Fill);

   Draw_Squares;
   PDF.Close;
end Drift;
