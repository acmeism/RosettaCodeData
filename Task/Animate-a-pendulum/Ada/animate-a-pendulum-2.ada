with Ada.Numerics.Generic_Elementary_Functions;
package body Pendulums is
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Float_Type);

   function New_Pendulum (Length : Float_Type;
                          Theta0 : Float_Type) return Pendulum is
      Result : Pendulum;
   begin
      Result.Length   := Length;
      Result.Theta    := Theta0 / 180.0 * Ada.Numerics.Pi;
      Result.X        := Math.Sin (Theta0) * Length;
      Result.Y        := Math.Cos (Theta0) * Length;
      Result.Velocity := 0.0;
      return Result;
   end New_Pendulum;

   function Get_X (From : Pendulum) return Float_Type is
   begin
      return From.X;
   end Get_X;

   function Get_Y (From : Pendulum) return Float_Type is
   begin
      return From.Y;
   end Get_Y;

   procedure Update_Pendulum (Item : in out Pendulum; Time : in Duration) is
      Acceleration : constant Float_Type := Gravitation / Item.Length *
                                            Math.Sin (Item.Theta);
   begin
         Item.X        := Math.Sin (Item.Theta) * Item.Length;
         Item.Y        := Math.Cos (Item.Theta) * Item.Length;
         Item.Velocity := Item.Velocity +
                          Acceleration  * Float_Type (Time);
         Item.Theta    := Item.Theta +
                          Item.Velocity * Float_Type (Time);
   end Update_Pendulum;
end Pendulums;
