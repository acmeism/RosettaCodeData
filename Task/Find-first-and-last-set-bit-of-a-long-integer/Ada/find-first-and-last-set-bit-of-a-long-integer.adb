with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Unchecked_Conversion;

procedure Find_Last_Bit is

   type My_Integer is range -2**63 .. 2**63 - 1;

   procedure Find_Set_Bits (Value   : in     My_Integer;
                            MSB_Bit :    out Integer;
                            LSB_Bit :    out Integer)
   is
      type Bit_Field is array (0 .. My_Integer'Size - 1) of Boolean;
      pragma Pack (Bit_Field);
      for Bit_Field'Size use My_Integer'Size;

      function To_Field is
         new Ada.Unchecked_Conversion (My_Integer, Bit_Field);

      Field : constant Bit_Field := To_Field (Value);
   begin

      LSB_Bit := -1;
      MSB_Bit := -1;

      for Bit in Field'Range loop
         if Field (Bit) then
            LSB_Bit := Bit;
            exit;
         end if;
      end loop;

      for Bit in reverse Field'Range loop
         if Field (Bit) then
            MSB_Bit := Bit;
            exit;
         end if;
      end loop;
   end Find_Set_Bits;


   procedure Put_Result (Value : in My_Integer) is
      package My_Integer_IO is
         new Ada.Text_IO.Integer_IO (My_Integer);
      use Ada.Text_IO;
      use Ada.Integer_Text_IO;
      Use My_Integer_IO;

      LSB_Bit, MSB_Bit : Integer;
      Placeholder : String := " MSB XX LSB YY";
      Image_MSB     : String renames Placeholder ( 6 ..  7);
      Image_LSB     : String renames Placeholder (13 .. 14);
   begin
      Find_Set_Bits (Value,
                     MSB_Bit => MSB_Bit,
                     LSB_Bit => LSB_Bit);
      Put (Value, Width => 18);
      Put (Value, Width => 66, Base => 2);
      Put (Image_MSB, MSB_Bit);
      Put (Image_LSB, LSB_Bit);
      Put_Line (Placeholder);
   end Put_Result;

begin
   Put_Result (Value => 0);
   for A in 0 .. 11 loop
      Put_Result (Value => 42 ** A);
   end loop;
end Find_Last_Bit;
