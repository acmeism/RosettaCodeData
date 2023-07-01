with Ada.Streams.Stream_IO;  use Ada.Streams.Stream_IO;
with Bit_Streams;            use Bit_Streams;

procedure Test_Bit_Streams is
   File   : File_Type;
   ABACUS : Bit_Array :=
               (  1,0,0,0,0,0,1,  -- A, big endian
                  1,0,0,0,0,1,0,  -- B
                  1,0,0,0,0,0,1,  -- A
                  1,0,0,0,0,1,1,  -- C
                  1,0,1,0,1,0,1,  -- U
                  1,0,1,0,0,1,1   -- S
               );
   Data : Bit_Array (ABACUS'Range);
begin
   Create (File, Out_File, "abacus.dat");
   declare
      Bits : Bit_Stream (Stream (File));
   begin
      Write (Bits, ABACUS);
   end;
   Close (File);
   Open (File, In_File, "abacus.dat");
   declare
      Bits : Bit_Stream (Stream (File));
   begin
      Read (Bits, Data);
   end;
   Close (File);
   if Data /= ABACUS then
      raise Data_Error;
   end if;
end Test_Bit_Streams;
