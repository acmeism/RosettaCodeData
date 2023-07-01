generic
   type Element_Type is private;
package Generic_Stack is
   type Stack is private;
   procedure Push (Item : Element_Type; Onto : in out Stack);
   procedure Pop (Item : out Element_Type; From : in out Stack);
   function Create return Stack;
   Stack_Empty_Error : exception;
private
   type Node;
   type Stack is access Node;
   type Node is record
      Element : Element_Type;
      Next    : Stack        := null;
   end record;
end Generic_Stack;
