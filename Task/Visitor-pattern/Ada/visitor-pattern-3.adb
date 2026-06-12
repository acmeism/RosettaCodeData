with Vehicle_Elements;

package Car_Visitors is

   type Print_Visitor is new Vehicle_Elements.Element_Visitor with null record;
   overriding procedure Visit
     (Self : Print_Visitor; Part : in out Vehicle_Elements.Element'Class);

   type Perform_Visitor is
   new Vehicle_Elements.Element_Visitor with null record;
   overriding procedure Visit
     (Self : Perform_Visitor; Part : in out Vehicle_Elements.Element'Class);

end Car_Visitors;
