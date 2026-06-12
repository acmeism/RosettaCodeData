package body Vehicle_Elements is

   --  Need a non abstract type to actually work in the Make function
   type Factory is new Element with null record;

   function Make (Name : String) return Element'Class is
     (Factory'(Name => To_Unbounded_String (Name)));

   function Name (Self : Element'Class) return String is
     (To_String (Self.Name));

   procedure Accept_Visitor
     (Self : in out Element; Visitor : Element_Visitor'Class)
   is
   begin
      Visitor.Visit (Self);
   end Accept_Visitor;

end Vehicle_Elements;
