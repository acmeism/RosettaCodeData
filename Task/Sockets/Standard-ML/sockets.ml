val txt = Word8VectorSlice.full (Byte.stringToBytes  "hello world"   ) ;
val set = fn socket => fn ipnr => fn portnr => fn text =>
 (
  Socket.connect (socket, INetSock.toAddr ( Option.valOf (NetHostDB.fromString(ipnr) ) , portnr )) ;
  Socket.sendVec(socket, text)  before Socket.close socket
 )
;
