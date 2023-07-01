with Ada.Text_IO;

with PDF_Out;

procedure Pinstripe_Printer
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
      Count  : constant Natural
        := Natural (Real'Floor (Screen_Width / (2.0 * Line_Width)));
      Corner      : constant Point := (Doc.Left_Margin, Doc.Bottom_Margin);
      Corner_Box  : constant Point := Corner     + (10.0, 10.0);
      Corner_Text : constant Point := Corner_Box + (10.0, 10.0);
      Light_Gray  : constant Color_Type := (0.9, 0.9, 0.9);
      Image : String (1 .. 4);
   begin
      --  Pinstripes
      Doc.Color (Black);
      for A in 0 .. Count loop
         Doc.Draw (What => Corner +
                     Rectangle'(X_Min  => 2.0 * Real (A) * Line_Width,
                                Y_Min  => Y,
                                Width  => Line_Width,
                                Height => Line_Height),
                   Rendering => Fill);
      end loop;

      --  Box
      Doc.Stroking_Color (Black);
      Doc.Color (Light_Gray);
      Doc.Line_Width (3.0);
      Doc.Draw (What => Corner_Box + (0.0, Y, 120.0, 26.0),
                Rendering => Fill_Then_Stroke);
      --  Text
      Doc.Color (Black);
      Doc.Text_Rendering_Mode (Fill);
      Point_Io.Put (Image, Line_Width, Aft => 1, Exp => 0);
      Doc.Put_XY (Corner_Text.X, Corner_Text.Y + Y,
                  Image & " point pinstripe");
   end Pinstripe;

   Doc : PDF_Out_File;
begin
   Doc.Create ("pinstripe.pdf");
   Doc.Page_Setup (A4_Portrait);
   Doc.Margins (Margins_Type'(Left   => Cm_2_5,
                              others => One_cm));
   declare
      Width  : constant Real
        := A4_Portrait.Width - Doc.Left_Margin - Doc.Right_Margin;
      Height : constant Real
        := A4_Portrait.Height - Doc.Top_Margin - Doc.Bottom_Margin;
   begin
      Pinstripe (Doc, 1.0, One_Inch, Width, Height - 1.0 * One_Inch);
      Pinstripe (Doc, 2.0, One_Inch, Width, Height - 2.0 * One_Inch);
      Pinstripe (Doc, 3.0, One_Inch, Width, Height - 3.0 * One_Inch);
      Pinstripe (Doc, 4.0, One_inch, Width, Height - 4.0 * One_Inch);
      Pinstripe (Doc, 5.0, One_Inch, Width, Height - 5.0 * One_Inch);
      Pinstripe (Doc, 6.0, One_Inch, Width, Height - 6.0 * One_Inch);
      Pinstripe (Doc, 7.0, One_Inch, Width, Height - 7.0 * One_Inch);
      Pinstripe (Doc, 8.0, One_Inch, Width, Height - 8.0 * One_Inch);
      Pinstripe (Doc, 9.0, One_Inch, Width, Height - 9.0 * One_Inch);
      Pinstripe (Doc, 10.0, One_Inch, Width, Height - 10.0 * One_Inch);
      Pinstripe (Doc, 11.0, One_Inch, Width, Height - 11.0 * One_Inch);
   end;
   Doc.Close;
end Pinstripe_Printer;
