with Ada.Unchecked_Deallocation;

package body Fifo is

   ----------
   -- Push --
   ----------

   procedure Push (List : in out Fifo_Type; Item : in Element_Type) is
      Temp : Fifo_Ptr := new Fifo_Element'(Item, null);
   begin
      if List.Tail = null then
         List.Tail := Temp;
      end if;
      if List.Head /= null then
        List.Head.Next := Temp;
      end if;
      List.Head := Temp;
   end Push;

   ---------
   -- Pop --
   ---------

   procedure Pop (List : in out Fifo_Type; Item : out Element_Type) is
      procedure Free is new Ada.Unchecked_Deallocation(Fifo_Element, Fifo_Ptr);
      Temp : Fifo_Ptr := List.Tail;
   begin
      if List.Head = null then
         raise Empty_Error;
      end if;
      Item := List.Tail.Value;
      List.Tail := List.Tail.Next;
      if List.Tail = null then
         List.Head := null;
      end if;
      Free(Temp);
   end Pop;

   --------------
   -- Is_Empty --
   --------------

   function Is_Empty (List : Fifo_Type) return Boolean is
   begin
      return List.Head = null;
   end Is_Empty;

end Fifo;
