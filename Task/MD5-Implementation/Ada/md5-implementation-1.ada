package MD5 is

   type Int32 is mod 2 ** 32;
   type MD5_Hash is array (1 .. 4) of Int32;
   function MD5 (Input : String) return MD5_Hash;

   -- 32 hexadecimal characters + '0x' prefix
   subtype MD5_String is String (1 .. 34);
   function To_String (Item : MD5_Hash) return MD5_String;

end MD5;
