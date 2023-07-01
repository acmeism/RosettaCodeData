var net = require('net')

conn = net.createConnection(3000, '192.168.1.x')

conn.on('connect', function(){
	console.log('connected')
	conn.write('test')
})

conn.on('data', function(msg){
	console.log(msg.toString())
})
