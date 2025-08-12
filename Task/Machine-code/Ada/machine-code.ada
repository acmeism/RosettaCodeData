--  Linux x86_64 with GNAT 15.1.0

with Ada.Unchecked_Conversion;
with Ada.Text_IO;
with Interfaces.C;
with System;

--  Pull in primitive operations for unsigned int types to combine
--  flags with "or"
use type Interfaces.C.unsigned;

procedure Machine_Code_Add is
   --  The mmap interface provided by GNAT is limited, expecting only
   --  reading and writing files rather than grabbing anonymous
   --  executable memory regions. At that point it's easier just to
   --  define our own interface.

   PROT_READ : constant Interfaces.C.unsigned := 1;
   PROT_WRITE : constant Interfaces.C.unsigned := 2;
   PROT_EXEC : constant Interfaces.C.unsigned := 4;
   MAP_PRIVATE : constant Interfaces.C.unsigned := 2;
   MAP_ANON : constant Interfaces.C.unsigned := 32;

   function Mmap (addr : System.Address;
                  len : Interfaces.C.size_t;
                  prot : Interfaces.C.unsigned;
                  flags : Interfaces.C.unsigned;
                  fd : Interfaces.C.unsigned;
                  off : Interfaces.C.long) return System.Address;
   pragma Import (C, Mmap, "mmap");

   function Munmap (addr : System.Address;
                    len : Interfaces.C.size_t) return Interfaces.C.int;
   pragma Import (C, Munmap, "munmap");

   function Memcpy (dest, src : System.Address; n : Interfaces.C.size_t)
     return System.Address;
   pragma Import (C, Memcpy, "memcpy");

   type Add_Fn is access
     function (A, B : Interfaces.C.long) return Interfaces.C.long
     with Convention => C;

   function To_Add_Fn is
     new Ada.Unchecked_Conversion (System.Address, Add_Fn);

   Code : constant array (Positive range 1 .. 7)
   of Interfaces.C.unsigned_char :=
     (16#48#, 16#89#, 16#F8#, 16#48#, 16#01#, 16#F0#, 16#C3#);

   Len : constant Interfaces.C.size_t := Code'Length;

   Mem : constant System.Address :=
     Mmap (System.Null_Address,
           Len,
           PROT_READ or PROT_WRITE or PROT_EXEC,
           MAP_PRIVATE or MAP_ANON,
           -1,
           0);

   Add : constant Add_Fn := To_Add_Fn (Mem);
   Dummy : System.Address := Memcpy (Mem, Code'Address, Len);
   Dummy2 : Interfaces.C.int;
   Sum : Interfaces.C.long := Add (12, 7);
begin
   Ada.Text_IO.Put_Line ("12 + 7 =" & Interfaces.C.long'Image (Sum));
   Dummy2 := Munmap (Mem, Len);
end Machine_Code_Add;
