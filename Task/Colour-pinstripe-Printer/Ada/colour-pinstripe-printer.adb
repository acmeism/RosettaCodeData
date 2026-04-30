with Ada.Text_IO;

with PDF_Out;

procedure Color_Pinstripe_Printer
is
   use PDF_Out;

   package Point_IO
   is new Ada.Text_Io.Float_IO (Real);

   procedure Pinstripe (Doc          : in out Pdf_Out_File;
                        Line_Width   : Real;
                        Line_Height  : Real;
                        Screen_Width : Real;
                        Y            : Real)
   is
      type Color_Range is (Blck, Red, Green, Blue, Magenta, Cyan, Yellow, White);
      Colors : constant array (Color_Range) of Color_Type
        := (Blck    => (0.0, 0.0, 0.0), Red   => (1.0, 0.0, 0.0),
            Green   => (0.0, 1.0, 0.0), Blue  => (0.0, 0.0, 1.0),
            Magenta => (1.0, 0.0, 1.0), Cyan  => (0.0, 1.0, 1.0),
            Yellow  => (1.0, 1.0, 0.0), White => (1.0, 1.0, 1.0));
      Col : Color_Range := Color_Range'First;

      Count  : constant Natural
        := Natural (Real'Floor (Screen_Width / Line_Width));
      Corner      : constant Point := (Doc.Left_Margin, Doc.Bottom_Margin);
      Corner_Box  : constant Point := Corner     + (10.0, 10.0);
      Corner_Text : constant Point := Corner_Box + (10.0, 10.0);
      Light_Gray  : constant Color_Type := (0.9, 0.9, 0.9);
      Image : String (1 .. 4);
   begin
      --  Pinstripes
      for A in 0 .. Count loop
         Doc.Color (Colors (Col));
         Doc.Draw (What => Corner +
                     Rectangle'(X_Min  => Real (A) * Line_Width,
                                Y_Min  => Y,
                                Width  => Line_Width,
                                Height => Line_Height),
                   Rendering => Fill);
         Col := (if Col = Color_Range'Last
                 then Color_Range'First
                 else Color_Range'Succ (Col));
      end loop;

      --  Box
      Doc.Stroking_Color (Black);
      Doc.Color (Light_Gray);
      Doc.Line_Width (3.0);
      Doc.Draw (What => Corner_Box + (0.0, Y, 150.0, 26.0),
                Rendering => Fill_Then_Stroke);
      --  Text
      Doc.Color (Black);
      Doc.Text_Rendering_Mode (Fill);
      Point_Io.Put (Image, Line_Width, Aft => 1, Exp => 0);
      Doc.Put_XY (Corner_Text.X, Corner_Text.Y + Y,
                  Image & " point color pinstripe");
   end Pinstripe;

   Doc : PDF_Out_File;
begin
   Doc.Create ("color-pinstripe.pdf");
   Doc.Page_Setup (A4_Portrait);
   Doc.Margins (Margins_Type'(Left   => Cm_2_5,
                              others => One_cm));
   declare
      Width  : constant Real
        := A4_Portrait.Width - Doc.Left_Margin - Doc.Right_Margin;
      Height : constant Real
        := A4_Portrait.Height - Doc.Top_Margin - Doc.Bottom_Margin;
   begin
      for Point in 1 .. 11 loop
         Pinstripe (Doc,
                    Line_Width   => Real (Point),
                    Line_Height  => One_Inch,
                    Screen_Width => Width,
                    Y            => Height - Real (Point) * One_Inch);
      end loop;
   end;
   Doc.Close;
end Color_Pinstripe_Printer;
