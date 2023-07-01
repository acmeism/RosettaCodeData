package LZW is

   MAX_CODE : constant := 4095;

   type Codes is new Natural range 0 .. MAX_CODE;
   type Compressed_Data is array (Positive range <>) of Codes;

   function Compress (Cleartext : in String) return Compressed_Data;
   function Decompress (Data : in Compressed_Data) return String;

end LZW;
