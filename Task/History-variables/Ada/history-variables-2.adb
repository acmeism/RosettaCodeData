package body History_Variables is

   -- set and get
   procedure Set(V: in out Variable; Item: Item_Type) is
   begin
      V.History.Prepend(Item);
   end Set;

   function Get(V: Variable) return Item_Type is
   begin
      return V.History.First_Element;
   end Get;

   -- number of items in history (including the current one)
   function Defined(V: Variable) return Natural is
   begin
      return (1 + V.History.Last_Index) - V.History.First_Index;
   end Defined;

   -- non-destructively search
   function Peek(V: Variable; Generation: Natural := 1) return Item_Type is
      Index: Positive  := V.History.First_Index + Generation;
   begin
      if Index > V.History.Last_Index then
         raise Constraint_Error;
      end if;
      return V.History.Element(Index);
   end Peek;

   procedure  Undo(V: in out Variable) is
   begin
      V.History.Delete_First;
   end Undo;

end History_Variables;
