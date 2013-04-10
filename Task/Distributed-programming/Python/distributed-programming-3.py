#!/usr/bin/python
# -*- coding: utf-8 -*-

import BaseHTTPServer

HOST = "localhost"
PORT = 8000

# we just want to write own class, we replace do_GET method. This could be extended, I just added basics
# see; http://docs.python.org/lib/module-BaseHTTPServer.html
class MyHTTPHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        # send 200 (OK) message
        self.send_response(200)
        # send header
        self.send_header("Content-type", "text/html")
        self.end_headers()

        # send context
        self.wfile.write("<html><head><title>Our Web Title</title></head>")
        self.wfile.write("<body><p>This is our body. You wanted to visit <b>%s</b> page</p></body>" % self.path)
        self.wfile.write("</html>")

if __name__ == '__main__':
    server = BaseHTTPServer.HTTPServer((HOST, PORT), MyHTTPHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print 'Exiting...'
        server.server_close()
