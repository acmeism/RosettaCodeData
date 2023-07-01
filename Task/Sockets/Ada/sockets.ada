with GNAT.Sockets;  use GNAT.Sockets;

procedure Socket_Send is
   Client : Socket_Type;
begin
   Initialize;
   Create_Socket  (Socket => Client);
   Connect_Socket (Socket => Client,
                   Server => (Family => Family_Inet,
                              Addr   => Inet_Addr ("127.0.0.1"),
                              Port   => 256));
   String'Write (Stream (Client), "hello socket world");
   Close_Socket (Client);
end Socket_Send;
