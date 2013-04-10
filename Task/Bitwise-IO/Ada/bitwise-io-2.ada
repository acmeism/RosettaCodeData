package body Bit_Streams is
   procedure Finalize (Stream : in out Bit_Stream) is
   begin
      if Stream.Write_Count > 0 then
         Stream.Output (1) := Stream.Output (1) * 2**(Stream_Element'Size - Stream.Write_Count);
         Stream.Channel.Write (Stream.Output);
      end if;
   end Finalize;
   procedure Read (Stream : in out Bit_Stream; Data : out Bit_Array) is
      Last : Stream_Element_Offset;
   begin
      for Index in Data'Range loop
         if Stream.Read_Count = 0 then
            Stream.Channel.Read (Stream.Input, Last);
            Stream.Read_Count := Stream_Element'Size;
         end if;
         Data (Index) := Bit (Stream.Input (1) / 2**(Stream_Element'Size - 1));
         Stream.Input (1)  := Stream.Input (1) * 2;
         Stream.Read_Count := Stream.Read_Count - 1;
      end loop;
   end Read;
   procedure Write (Stream : in out Bit_Stream; Data : Bit_Array) is
   begin
      for Index in Data'Range loop
         if Stream.Write_Count = Stream_Element'Size then
            Stream.Channel.Write (Stream.Output);
            Stream.Write_Count := 0;
         end if;
         Stream.Output (1)  := Stream.Output (1) * 2 or Stream_Element (Data (Index));
         Stream.Write_Count := Stream.Write_Count + 1;
      end loop;
   end Write;
end Bit_Streams;
