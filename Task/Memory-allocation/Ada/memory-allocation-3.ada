declare
   type Integer_Ptr is access Integer;
   procedure Free is new Ada.Unchecked_Deallocation (Integer, Integer_Ptr)
   Ptr : Integer_Ptr := new Integer; -- Allocated in the heap
begin
   Free (Ptr); -- Explicit deallocation
   ...
end;
