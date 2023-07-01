with Arena_Pools;
use  Arena_Pools;

procedure Test_Allocator is
   Pool : Arena_Pools.Arena (1024);
   type Integer_Ptr is access Integer;
   for Integer_Ptr'Storage_Pool use Pool;

   X : Integer_Ptr := new Integer'(1);
   Y : Integer_Ptr := new Integer'(2);
   Z : Integer_Ptr;
begin
   Z := new Integer;
   Z.all := X.all + Y.all;
end Test_Allocator;
