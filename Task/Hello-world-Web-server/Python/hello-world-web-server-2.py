import threading

from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


class HelloHTTPRequestHandler(BaseHTTPRequestHandler):

  message = 'Hello World! 今日は'

  def do_GET(self):
    self.send_response(200)
    self.send_header('Content-type', 'text/html; charset=UTF-8')
    self.end_headers()
    self.wfile.write(self.message.encode('utf-8'))
    self.close_connection = True


def serve(addr, port):
  with ThreadingHTTPServer((addr, port), HelloHTTPRequestHandler) as server:
    server.serve_forever(poll_interval=None)


if __name__ == '__main__':

  addr, port = ('localhost', 80)

  threading.Thread(target=serve, args=(addr, port), daemon=True).start()

  try:
    while True:
      # handle Ctrl+C
      input()

  except KeyboardInterrupt:
    pass
