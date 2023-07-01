(import (lib http))

(http:run 8080 (lambda (fd request headers send close)
   (send "HTTP/1.0 200 OK\n"
         "Connection: close\n"
         "Content-Type: text/html; charset=UTF-8\n"
         "Server: " (car *version*) "/" (cdr *version*)
         "\n\n"

         "<h1>Goodbye, World!</h1>"
         (ref request 1) ": " (ref request 2)
         "<hr><small>" headers "</small>")
   (close #t)
))
