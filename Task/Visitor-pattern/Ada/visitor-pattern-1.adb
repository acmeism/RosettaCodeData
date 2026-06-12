private with Ada.Strings.Unbounded;

package Vehicle_Elements is

   --  Forward declaration for visitor operation parameter
   type Element is tagged;

   --  Generic visitor interface
   type Element_Visitor is interface;

   --  Interface visiting procedure
   procedure Visit
     (Self :        Element_Visitor;
      Part : in out Vehicle_Elements.Element'Class) is abstract;

   --  Base class type for all car things
   type Element is abstract tagged private;

   --  Using 'Class here so I can provide a generic base class constructor
   --     Name - Name of the part: "Body", "Engine", "Wheel"
   --  NOTE:  When using to make an aggregate, type convert the result of this
   --     operation to the Element type
   function Make (Name : String) return Element'Class;

   --  To get the supplied name
   function Name (Self : Element'Class) return String;

   --  This procedure calls Visitor.Visit(Self) by default
   --  We can't call it `Accept` because `accept` is an Ada keyword...
   procedure Accept_Visitor
     (Self : in out Element; Visitor : Element_Visitor'Class);

private

   use Ada.Strings.Unbounded;

   type Element is abstract tagged record
      Name : Unbounded_String;
   end record;

end Vehicle_Elements;
