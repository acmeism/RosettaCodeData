var net = require('net')

var server = net.createServer(function (c){
  c.write('hello\r\n')
  c.pipe(c) // echo messages back
})

server.listen(3000, 'localhost')
