with Ada.Text_IO; use Ada.Text_IO;
with Bodies;
with Engines;
with Wheels;
with Cars;

package body Car_Visitors is

   overriding procedure Visit
     (Self : Print_Visitor; Part : in out Vehicle_Elements.Element'Class)
   is
   begin
      Put_Line ("Visiting " & Part.Name);
   end Visit;

   overriding procedure Visit
     (Self : Perform_Visitor; Part : in out Vehicle_Elements.Element'Class)
   is
   begin
      if Part in Cars.Car then
         Put_Line ("Starting the " & Part.Name);
      elsif Part in Bodies.Car_Body then
         Put_Line ("Moving the " & Part.Name);
      elsif Part in Engines.Engine then
         Put_Line ("Revving the " & Part.Name);
      elsif Part in Wheels.Wheel then
         Put_Line ("Rolling the " & Part.Name);
      else
         raise Constraint_Error
           with "Peform_Visitor does not support part type";
      end if;
   end Visit;

end Car_Visitors;
