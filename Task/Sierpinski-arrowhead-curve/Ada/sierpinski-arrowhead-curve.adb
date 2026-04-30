with Ada.Command_Line;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO;
with PDF_Out;

procedure Arrowhead_Curve is

   package Real_Math is
     new Ada.Numerics.Generic_Elementary_Functions (PDF_Out.Real);
   use Real_Math, PDF_Out, Ada.Command_Line, Ada.Text_IO;

   subtype Angle_Deg  is Real;
   type    Order_Type is range 0 .. 7;

   Purple : constant Color_Type := (0.7, 0.0, 0.5);
   Length : constant Real       := 340.0;
   Corner : constant Point      := (120.0, 480.0);

   Order     : Order_Type;
   Current   : Point      := (0.0, 0.0);
   Direction : Angle_Deg  := Angle_Deg'(0.0);
   Doc       : PDF_Out_File;

   procedure Curve (Order : Order_Type; Length : Real; Angle : Angle_Deg) is
   begin
      if Order = 0 then
         Current := Current + Length * Point'(Cos (Direction, 360.0),
                                              Sin (Direction, 360.0));
         Doc.Line (Corner + Current);
      else
         Curve (Order - 1, Length / 2.0, -Angle);  Direction := Direction + Angle;
         Curve (Order - 1, Length / 2.0,  Angle);  Direction := Direction + Angle;
         Curve (Order - 1, Length / 2.0, -Angle);
      end if;
   end Curve;

begin
   if Argument_Count /= 1 then
      Put_Line ("arrowhead_curve <order>");
      Put_Line ("  <order>   0 .. 7");
      Put_Line ("open sierpinski-arrowhead-curve.pdf to view ouput");
      return;
   end if;
   Order := Order_Type'Value (Argument (1));

   Doc.Create ("sierpinski-arrowhead-curve.pdf");
   Doc.Page_Setup (A4_Portrait);
   Doc.Margins (Margins_Type'(Left   => Cm_2_5,
                              others => One_cm));
   Doc.Stroking_Color (Purple);
   Doc.Line_Width (2.0);
   Doc.Move (Corner);
   if Order mod 2 = 0 then
      Direction := 0.0;
      Curve (Order, Length, 60.0);
   else
      Direction := 60.0;
      Curve (Order, Length, -60.0);
   end if;
   Doc.Finish_Path (Close_Path => False,
                    Rendering  => Stroke,
                    Rule       => Nonzero_Winding_Number);
   Doc.Close;
end Arrowhead_Curve;
