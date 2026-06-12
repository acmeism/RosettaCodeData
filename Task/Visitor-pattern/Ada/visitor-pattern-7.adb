with Vehicle_Elements;

package Wheels is

   type Wheel is new Vehicle_Elements.Element with null record;
   function Make (Name : String) return Wheel is
     (Vehicle_Elements.Element (Vehicle_Elements.Make (Name & " Wheel")) with
      null record);

end Wheels;
