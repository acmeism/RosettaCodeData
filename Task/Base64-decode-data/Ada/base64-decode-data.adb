with Ada.Text_IO;

with AWS.Translator;

procedure Decode_AWS is
   Input  : constant String :=
     "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVw" &
     "IHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=";
   Result : constant String := AWS.Translator.Base64_Decode (Input);
begin
   Ada.Text_IO.Put_Line (Input);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line (Result);
end Decode_AWS;
