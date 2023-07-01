val txt = Word8VectorSlice.full (Byte.stringToBytes  "hello world!"   ) ;

fun serve listener portnr =
 let
  fun next () =
   let
    val (conn, conn_addr) = Socket.accept listener
   in
    case  Posix.Process.fork () of
        NONE   =>
             (
	      Socket.sendVec(conn, txt); Socket.close conn ;
              OS.Process.exit OS.Process.success
             )
       | _     =>
             (
	      Socket.close conn ;next ()
	     )
    end
  in (
   Socket.Ctl.setREUSEADDR(listener, true);
   Socket.bind(listener, INetSock.any portnr );
   Socket.listen(listener, 9);
   next ()
   )
  end               handle x => (Socket.close listener; raise x)
;
