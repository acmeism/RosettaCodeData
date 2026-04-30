with Ada.Command_Line;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO;
with PDF_Out;

procedure Koch_Curve is

   package Real_Math is
     new Ada.Numerics.Generic_Elementary_Functions (PDF_Out.Real);
   use Real_Math, PDF_Out, Ada.Command_Line, Ada.Text_IO;

   subtype Angle_Deg  is Real;
   type    Level_Type is range 0 .. 7;

   Purple : constant Color_Type := (0.7, 0.0, 0.5);
   Length : constant Real       := 400.0;
   Corner : constant Point      := (90.0, 580.0);

   Level     : Level_Type;
   Current   : Point      := (0.0, 0.0);
   Direction : Angle_Deg  := Angle_Deg'(60.0);
   Doc       : PDF_Out_File;

   procedure Koch (Level : Level_Type; Length : Real) is
   begin
      if Level = 0 then
         Current := Current + Length * Point'(Sin (Direction, 360.0),
                                              Cos (Direction, 360.0));
         Doc.Line (Corner + Current);
      else
         Koch (Level - 1, Length / 3.0);  Direction := Direction -  60.0;
         Koch (Level - 1, Length / 3.0);  Direction := Direction + 120.0;
         Koch (Level - 1, Length / 3.0);  Direction := Direction -  60.0;
         Koch (Level - 1, Length / 3.0);
      end if;
   end Koch;

begin
   if Argument_Count /= 1 then
      Put_Line ("koch_curve <level>");
      Put_Line ("  <level>   0 .. 7");
      Put_Line ("open koch.pdf to view ouput");
      return;
   end if;
   Level := Level_Type'Value (Argument (1));

   Doc.Create ("koch.pdf");
   Doc.Page_Setup (A4_Portrait);
   Doc.Margins (Margins_Type'(Left   => Cm_2_5,
                              others => One_cm));
   Doc.Color (Purple);
   Doc.Move (Corner);
   for A in 1 .. 3 loop
      Koch (Level, Length);
      Direction := Direction + 120.0;
   end loop;
   Doc.Finish_Path (Close_Path => True,
                    Rendering  => Fill,
                    Rule       => Even_Odd);
   Doc.Close;
end Koch_Curve;
