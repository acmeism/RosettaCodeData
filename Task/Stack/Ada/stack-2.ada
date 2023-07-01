with Ada.Unchecked_Deallocation;

package body Generic_Stack is

   ------------
   -- Create --
   ------------

   function Create return Stack is
   begin
      return (null);
   end Create;

   ----------
   -- Push --
   ----------

   procedure Push(Item : Element_Type; Onto : in out Stack) is
      Temp : Stack := new Node;
   begin
      Temp.Element := Item;
      Temp.Next := Onto;
      Onto := Temp;
   end Push;

   ---------
   -- Pop --
   ---------

   procedure Pop(Item : out Element_Type; From : in out Stack) is
      procedure Free is new Ada.Unchecked_Deallocation(Node, Stack);
      Temp : Stack := From;
   begin
      if Temp = null then
         raise Stack_Empty_Error;
      end if;
      Item := Temp.Element;
      From := Temp.Next;
      Free(Temp);
   end Pop;

end Generic_Stack;
