Load "guilib.ring"

new qApp {
        oClient = new Client { client() }
        exec()
}

Class Client

        win1 oTcpSocket

        func client

                win1 = new qwidget()

                new qpushbutton(win1) {
                        setgeometry(50,50,100,30)
                        settext("connect")
                        setclickevent("oClient.Connect()")
                }

                win1 {
                        setwindowtitle("client")
                        setgeometry(10,100,400,400)
                        show()
                }

        func connect
                oTcpSocket = new qTcpSocket(win1) {
                        setconnectedevent("oClient.pConnected()")
                        connecttohost("127.0.0.1",256,3,0)
                        waitforconnected(5000)
                }

        func pConnected
                cStr = "hello socket world"
                write(cStr,len(cStr))
                flush()
                waitforbyteswritten(300000)
                close()
