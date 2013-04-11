(load "@lib/http.l")

(client "rosettacode.org" 80 NIL       # Connect to rosettacode
   (out NIL (echo)) )                  # Echo to standard output
