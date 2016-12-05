Load "guilib.ring"

cResponse = "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/html\r\n\r\n" +
               "<html><head><title>Goodbye, world!</title></head>" +
               "<body>Goodbye, world!</body></html>"

cResponse = substr(cResponse,"\r\n",char(13)+char(10))

new qApp {
	oServer = new Server { Server() }
	exec()
}

Class Server

        win1 lineedit1
        oTcpServer oTcpClient
        cOutput = ""

        func server

                win1 = new qwidget()

                lineedit1 = new qtextedit(win1) {
                        setGeometry(150,50,200,300)
                }

                win1 {
                        setwindowtitle("Server")
                        setgeometry(450,100,400,400)
                        show()
                }

                oTcpServer = new qTcpServer(win1) {		
                        setNewConnectionEvent("oServer.pNewConnection()")
                        oHostAddress = new qHostAddress()
                        oHostAddress.SetAddress("127.0.0.1")
                        listen(oHostAddress,8080)
                }
                cOutput = "Server Started" + nl +
                           "listen to port 8080" + nl

                lineedit1.settext(cOutput)

        Func pNewConnection

                oTcpClient = oTcpServer.nextPendingConnection()
                while not oTcpClient.waitForReadyRead(100) end
                cOutput += "Accept Connection" + nl
                lineedit1.settext(cOutput)
                oTcpClient {
                        write(cResponse,len(cResponse))
                        flush()
                        waitforbyteswritten(300000)
                        close()
                }
