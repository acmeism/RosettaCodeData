import net

var s = newSocket()
s.connect("localhost", Port(256))
s.send("Hello Socket World")
s.close()
