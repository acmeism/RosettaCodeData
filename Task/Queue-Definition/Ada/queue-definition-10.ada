generic
   type Element_Type is private;
package Asynchronous_Fifo is
   protected type Fifo is
      procedure Push(Item : Element_Type);
      entry Pop(Item : out Element_Type);
   private
      Value : Element_Type;
      Valid : Boolean := False;
   end Fifo;
end Asynchronous_Fifo;
