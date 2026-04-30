with Server;
with Ada.Text_IO;

procedure Client is
begin
   Ada.Text_IO.Put_Line ("Calling Foo...");
   Server.Foo;
   Ada.Text_IO.Put_Line ("Calling Bar: " & Integer'Image (Server.Bar));
end Client;
