generic
   type Element_Type is private;
package Synchronous_Fifo is
   protected type Fifo is
      entry Push(Item : Element_Type);
      entry Pop(Item : out Element_Type);
   private
      Value : Element_Type;
      Is_New : Boolean := False;
   end Fifo;
end Synchronous_Fifo;
