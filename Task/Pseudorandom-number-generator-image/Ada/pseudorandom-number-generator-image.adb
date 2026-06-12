-- Generate a (pseudo)random image
-- J. Carter     2023 Apr
-- Uses Ada_GUI (https://github.com/jrcarter/Ada_GUI)

with Ada.Numerics.Discrete_Random;
with Ada_GUI;

procedure Random_Image is
   package Color_Random is new Ada.Numerics.Discrete_Random (Result_Subtype => Ada_GUI.RGB_Value);

   Gen   : Color_Random.Generator;
   Image : Ada_GUI.Widget_ID;
   Event : Ada_GUI.Next_Result_Info;

   use type Ada_GUI.Event_Kind_ID;
begin -- Random_Image
   Color_Random.Reset (Gen => Gen);
   Ada_GUI.Set_Up (Title => "Random Image");
   Image := Ada_GUI.New_Graphic_Area (Width => 250, Height => 250);

   All_X : for X in 0 .. 249 loop
      All_Y : for Y in 0 .. 249 loop
         Image.Set_Pixel (X => X, Y => Y, Color => (Red   => Color_Random.Random (Gen),
                                                    Green => Color_Random.Random (Gen),
                                                    Blue  => Color_Random.Random (Gen),
                                                    Alpha => 1.0) );
      end loop All_Y;
   end loop All_X;

   Wait : loop
      Event := Ada_GUI.Next_Event;

      exit Wait when not Event.Timed_Out and then Event.Event.Kind = Ada_GUI.Window_Closed;
   end loop Wait;

   Ada_GUI.End_GUI;
end Random_Image;
