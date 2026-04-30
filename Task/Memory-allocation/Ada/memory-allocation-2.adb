declare
   type Integer_Ptr is access Integer;
   Ptr : Integer_Ptr := new Integer; -- Allocated in the heap
begin
   ...
end; -- Memory is freed because Integer_Ptr is finalized
