Program Sockets_ExampleB;

Uses
  sockets;

Var
  TCP_Sock:    integer;
  Remote_Addr: TSockAddr;

  Message:     string;
  PMessage:    Pchar;
  Message_Len: integer;

Begin
  Remote_Addr.Sin_family := AF_INET;
  Remote_Addr.Sin_addr   := StrToNetAddr('127.0.0.1');
  Remote_Addr.Sin_port   := HtoNs(256);

  TCP_Sock := fpSocket(AF_INET, SOCK_STREAM, IPPROTO_IP);

  fpConnect(TCP_Sock, @Remote_Addr, SizeOf(Remote_Addr));

  Message     := 'Hello socket world';
  PMessage    := @Message;
  Message_Len := StrLen(PMessage);

  fpSend(TCP_Sock, PMessage, Message_Len, 0);
End.
