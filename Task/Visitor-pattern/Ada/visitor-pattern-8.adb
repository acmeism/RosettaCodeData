private with Wheels;

with Bodies;
with Engines;
with Vehicle_Elements;

package Cars is

   type Car is new Vehicle_Elements.Element with private;

   overriding procedure Accept_Visitor
     (Self : in out Car; Visitor : Vehicle_Elements.Element_Visitor'Class);

   function Make return Car;

private

   type Wheel_Position is (Left_Front, Right_Front, Left_Back, Right_Back);

   type Wheel_Array is array (Wheel_Position) of Wheels.Wheel;

   type Car is new Vehicle_Elements.Element with record
      Car_Body   : Bodies.Car_Body;
      Engine     : Engines.Engine;
      All_Wheels : Wheel_Array;
   end record;

end Cars;
