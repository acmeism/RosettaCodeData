with Ada.Finalization;
...
type Node is abstract new Ada.Finalization.Limited_Controlled and Queue with record
   Previous : not null access Node'Class := Node'Unchecked_Access;
   Next     : not null access Node'Class := Node'Unchecked_Access;
end record;
overriding procedure Finalize (X : in out Node); -- Removes the node from its list if any
overriding procedure Dequeue (Lounge : in out Node; Item : in out Element);
overriding procedure Enqueue (Lounge : in out Node; Item : in out Element);
procedure Process (X : in out Node) is abstract; -- To be implemented
