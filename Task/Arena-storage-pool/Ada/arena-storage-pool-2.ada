with System.Storage_Elements;  use System.Storage_Elements;
with System.Storage_Pools;     use System.Storage_Pools;

package Arena_Pools is
   type Arena (Size : Storage_Count) is new Root_Storage_Pool with private;
   overriding
      procedure Allocate
                (  Pool      : in out Arena;
                   Address   : out System.Address;
                   Size      : Storage_Count;
                   Alignment : Storage_Count
                );
   overriding
      procedure Deallocate
                (  Pool      : in out Arena;
                   Address   : System.Address;
                   Size      : Storage_Count;
                   Alignment : Storage_Count
                )  is null;
   overriding
      function Storage_Size (Pool : Arena) return Storage_Count;
private
   type Arena (Size : Storage_Count) is new Root_Storage_Pool with record
      Free : Storage_Offset := 1;
      Core : Storage_Array (1..Size);
   end record;
end Arena_Pools;
