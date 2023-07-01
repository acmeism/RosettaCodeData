const net = require('net');

function handleClient(conn) {
    console.log('Connection from ' + conn.remoteAddress + ' on port ' + conn.remotePort);

    conn.setEncoding('utf-8');

    let buffer = '';

    function handleData(data) {
        for (let i = 0; i < data.length; i++) {
            const char = data.charAt(i);
            buffer += char;
            if (char === '\n') {
                conn.write(buffer);
                buffer = '';
            }
        }
    }

    conn.on('data', handleData);
}

net.createServer(handleClient).listen(12321, 'localhost');
