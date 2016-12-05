local(server) = net_tcp
handle => { #server->close }
#server->bind(8080) & listen & forEachAccept => {
   local(con) = #1

   split_thread => {
      handle => { #con->close }
      local(request) = ''
      // Read in the request in chunks until you have it all
      {
         #request->append(#con->readSomeBytes(8096))
         not #request->contains('\r\n\r\n')? currentCapture->restart
      }()

      local(response) = 'HTTP/1.1 200 OK\r\n\
            Content-Type: text/html; charset=UTF-8\r\n\r\n\
            Goodbye, World!'
      #con->writeBytes(bytes(#response))
   }
}
