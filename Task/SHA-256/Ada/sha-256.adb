with Ada.Text_IO;

with CryptAda.Pragmatics;
with CryptAda.Digests.Message_Digests.SHA_256;
with CryptAda.Digests.Hashes;
with CryptAda.Utils.Format;

procedure RC_SHA_256 is
   use CryptAda.Pragmatics;
   use CryptAda.Digests.Message_Digests;
   use CryptAda.Digests;

   function To_Byte_Array (Item : String) return Byte_Array is
      Result : Byte_Array (Item'Range);
   begin
      for I in Result'Range loop
         Result (I) := Byte (Character'Pos (Item (I)));
      end loop;
      return Result;
   end To_Byte_Array;

   Text    : constant String                := "Rosetta code";
   Bytes   : constant Byte_Array            := To_Byte_Array (Text);
   Handle  : constant Message_Digest_Handle := SHA_256.Get_Message_Digest_Handle;
   Pointer : constant Message_Digest_Ptr    := Get_Message_Digest_Ptr (Handle);
   Hash    : Hashes.Hash;
begin
   Digest_Start  (Pointer);
   Digest_Update (Pointer, Bytes);
   Digest_End    (Pointer, Hash);

   Ada.Text_IO.Put_Line
     ("""" & Text & """: " & CryptAda.Utils.Format.To_Hex_String (Hashes.Get_Bytes (Hash)));
end RC_SHA_256;
