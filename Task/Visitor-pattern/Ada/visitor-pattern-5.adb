with Vehicle_Elements;

package Bodies is

   type Car_Body is new Vehicle_Elements.Element with null record;
   function Make return Car_Body is
     (Vehicle_Elements.Element (Vehicle_Elements.Make ("Body")) with
      null record);

end Bodies;
