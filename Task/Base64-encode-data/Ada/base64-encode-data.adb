with Ada.Text_IO;

with AWS.Response;
with AWS.Client;
with AWS.Translator;

procedure Encode_AWS is
   URL     : constant String := "http://rosettacode.org/favicon.ico";
   Page    : constant AWS.Response.Data := AWS.Client.Get (URL);
   Payload : constant String := AWS.Response.Message_Body (Page);
   Icon_64 : constant String := AWS.Translator.Base64_Encode (Payload);
begin
   Ada.Text_IO.Put_Line (Icon_64);
end Encode_AWS;
