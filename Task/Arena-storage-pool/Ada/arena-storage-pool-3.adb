package body Arena_Pools is
   procedure Allocate
             (  Pool      : in out Arena;
                Address   : out System.Address;
                Size      : Storage_Count;
                Alignment : Storage_Count
             )  is
      Free : constant Storage_Offset :=
         Pool.Free + Alignment - Pool.Core (Pool.Free)'Address mod Alignment + Size;
   begin
      if Free - 1 > Pool.Size then
         raise Storage_Error;
      end if;
      Pool.Free := Free;
      Address := Pool.Core (Pool.Free - Size)'Address;
   end Allocate;

   function Storage_Size (Pool : Arena) return Storage_Count is
   begin
      return Pool.Size;
   end Storage_Size;
end Arena_Pools;
