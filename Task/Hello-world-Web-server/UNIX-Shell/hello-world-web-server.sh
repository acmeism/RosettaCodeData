while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; echo 'Hello, World!'; } | nc -l 8080; done
