pragma Ada_2022;

package body Cars is

   function Make return Car is
     (Vehicle_Elements.Element (Vehicle_Elements.Make ("Car")) with
      Car_Body   => Bodies.Make, Engine => Engines.Make,
      All_Wheels =>
        (for Wheel in Wheel_Position => Wheels.Make (Wheel'Image)));

   overriding procedure Accept_Visitor
     (Self : in out Car; Visitor : Vehicle_Elements.Element_Visitor'Class)
   is
   begin
      Vehicle_Elements.Element (Self).Accept_Visitor (Visitor);
      Self.Car_Body.Accept_Visitor (Visitor);
      Self.Engine.Accept_Visitor (Visitor);
      for Wheel of Self.All_Wheels loop
         Wheel.Accept_Visitor (Visitor);
      end loop;
   end Accept_Visitor;

end Cars;
