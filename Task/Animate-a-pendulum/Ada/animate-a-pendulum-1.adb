generic
   type Float_Type is digits <>;
   Gravitation : Float_Type;
package Pendulums is
   type Pendulum is private;
   function New_Pendulum (Length : Float_Type;
                          Theta0 : Float_Type) return Pendulum;
   function Get_X (From : Pendulum) return Float_Type;
   function Get_Y (From : Pendulum) return Float_Type;
   procedure Update_Pendulum (Item : in out Pendulum; Time : in Duration);
private
   type Pendulum is record
      Length   : Float_Type;
      Theta    : Float_Type;
      X        : Float_Type;
      Y        : Float_Type;
      Velocity : Float_Type;
   end record;
end Pendulums;
