generic
   type Element_Type is private;
package Fifo is
   type Fifo_Type is private;
   procedure Push(List : in out Fifo_Type; Item : in Element_Type);
   procedure Pop(List : in out Fifo_Type; Item : out Element_Type);
   function Is_Empty(List : Fifo_Type) return Boolean;
   Empty_Error : exception;
private
   type Fifo_Element;
   type Fifo_Ptr is access Fifo_Element;
   type Fifo_Type is record
      Head : Fifo_Ptr := null;
      Tail : Fifo_Ptr := null;
   end record;
   type Fifo_Element is record
      Value : Element_Type;
      Next  : Fifo_Ptr := null;
   end record;
end Fifo;
