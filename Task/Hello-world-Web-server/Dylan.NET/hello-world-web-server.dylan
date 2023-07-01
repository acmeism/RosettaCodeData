//compile with dylan.NET 11.5.1.2 or later!!
#refstdasm "mscorlib.dll"
#refstdasm "System.dll"

import System.Text
import System.Net.Sockets
import System.Net

assembly helloweb exe
ver 1.1.0.0

namespace WebServer

    class public GoodByeWorld

        method public static void main(var args as string[])

            var msg as string = c"<html>\n<body>\nGoodbye, world!\n</body>\n</html>\n"
            var port as integer = 8080
            var serverRunning as boolean = true

            var tcpListener as TcpListener = new TcpListener(IPAddress::Any, port)
            tcpListener::Start()

            do while serverRunning
                var socketConnection as Socket = tcpListener::AcceptSocket()
                var bMsg as byte[] = Encoding::get_ASCII()::GetBytes(msg::ToCharArray(), 0, msg::get_Length())
                socketConnection::Send(bMsg)
                socketConnection::Disconnect(true)
            end do

        end method

    end class

end namespace
