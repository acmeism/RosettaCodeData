with Ada.Streams;  use Ada.Streams;
with Ada.Finalization;

package Bit_Streams is
   type Bit is range 0..1;
   type Bit_Array is array (Positive range <>) of Bit;
   type Bit_Stream (Channel : not null access Root_Stream_Type'Class) is limited private;
   procedure Read (Stream : in out Bit_Stream; Data : out Bit_Array);
   procedure Write (Stream : in out Bit_Stream; Data : Bit_Array);
private
   type Bit_Stream (Channel : not null access Root_Stream_Type'Class) is
      new Ada.Finalization.Limited_Controlled with
   record
      Read_Count  : Natural := 0;
      Write_Count : Natural := 0;
      Input       : Stream_Element_Array (1..1);
      Output      : Stream_Element_Array (1..1);
   end record;
   overriding procedure Finalize (Stream : in out Bit_Stream);
end Bit_Streams;
