Program Sockets_ExampleA;

Uses
  { Free Pascal RTL sockets unit }
  sockets;

Var
  TCP_Sock:    integer;
  Remote_Addr: TSockAddr;

  Message:     string;
  PMessage:    Pchar;
  Message_Len: integer;


Begin
  { Fill the record (struct) with the server's address information }
  With Remote_Addr do
  begin
    Sin_family := AF_INET;
    Sin_addr   := StrToNetAddr('127.0.0.1');
    Sin_port   := HtoNs(256);
  end;

  { Returns an IPv4 TCP socket descriptor }
  TCP_Sock := fpSocket(AF_INET, SOCK_STREAM, IPPROTO_IP);

  { Most routines in this unit return -1 on failure }
  If TCP_Sock = -1 then
  begin
    WriteLn('Failed to create new socket descriptor');
    Halt(1);
  end;

  { Attempt to connect to the address supplied above }
  If fpConnect(TCP_Sock, @Remote_Addr, SizeOf(Remote_Addr)) = -1 then
  begin
    { Specifc error codes can be retrieved by calling the SocketError function }
    WriteLn('Failed to contact server');
    Halt(1);
  end;

  { Finally, send the message to the server and disconnect }
  Message     := 'Hello socket world';
  PMessage    := @Message;
  Message_Len := StrLen(PMessage);

  If fpSend(TCP_Sock, PMessage, Message_Len, 0) <> Message_Len then
  begin
    WriteLn('An error occurred while sending data to the server');
    Halt(1);
  end;

  CloseSocket(TCP_Sock);
End.
