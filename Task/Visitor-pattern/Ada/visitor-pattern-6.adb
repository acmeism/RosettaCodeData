with Vehicle_Elements;

package Engines is

   type Engine is new Vehicle_Elements.Element with null record;
   function Make return Engine is
     (Vehicle_Elements.Element (Vehicle_Elements.Make ("Engine")) with
      null record);

end Engines;
