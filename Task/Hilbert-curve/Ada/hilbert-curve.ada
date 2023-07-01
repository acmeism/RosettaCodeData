with PDF_Out;  use PDF_Out;

procedure Hilbert_Curve_PDF is

   Length  : constant := 500.0;
   Corner  : constant Point := (50.0, 300.0);

   type Rule_Type is (A, B, C, D);

   PDF   : PDF_Out.Pdf_Out_File;
   First : Boolean;

   procedure Hilbert (Order  : in Natural;
                      Rule   : in Rule_Type;
                      Length : in Real;
                      X, Y   : in Real)
   is
      L : constant Real := Length / 4.0;
   begin
      if Order = 0 then
         if First then
            First := False;
            PDF.Move (Corner + (X, Y));
         else
            PDF.Line (Corner + (X, Y));
         end if;
      else
         case Rule is
            when A =>
               Hilbert (Order - 1, D, 2.0 * L, X - L, Y + L);
               Hilbert (Order - 1, A, 2.0 * L, X - L, Y - L);
               Hilbert (Order - 1, A, 2.0 * L, X + L, Y - L);
               Hilbert (Order - 1, B, 2.0 * L, X + L, Y + L);
            when B =>
               Hilbert (Order - 1, C, 2.0 * L, X + L, Y - L);
               Hilbert (Order - 1, B, 2.0 * L, X - L, Y - L);
               Hilbert (Order - 1, B, 2.0 * L, X - L, Y + L);
               Hilbert (Order - 1, A, 2.0 * L, X + L, Y + L);
            when C =>
               Hilbert (Order - 1, B, 2.0 * L, X + L, Y - L);
               Hilbert (Order - 1, C, 2.0 * L, X + L, Y + L);
               Hilbert (Order - 1, C, 2.0 * L, X - L, Y + L);
               Hilbert (Order - 1, D, 2.0 * L, X - L, Y - L);
            when D =>
               Hilbert (Order - 1, A, 2.0 * L, X - L, Y + L);
               Hilbert (Order - 1, D, 2.0 * L, X + L, Y + L);
               Hilbert (Order - 1, D, 2.0 * L, X + L, Y - L);
               Hilbert (Order - 1, C, 2.0 * L, X - L, Y - L);
         end case;
      end if;
   end Hilbert;

   procedure Hilbert (Order : Natural; Color : Color_Type) is
   begin
      First := True;
      PDF.Stroking_Color (Color);
      Hilbert (Order, A, Length, Length / 2.0, Length / 2.0);
      PDF.Finish_Path (Close_Path => False,
                       Rendering  => Stroke,
                       Rule       => Nonzero_Winding_Number);
   end Hilbert;

begin
   PDF.Create ("hilbert.pdf");
   PDF.Page_Setup (A4_Portrait);
   PDF.Line_Width (2.0);

   PDF.Color (Black);
   PDF.Draw (Corner + (0.0, 0.0, Length, Length), Fill);

   Hilbert (6, Color => (0.9, 0.1, 0.8));
   Hilbert (5, Color => (0.0, 0.9, 0.0));

   PDF.Close;
end Hilbert_Curve_PDF;
