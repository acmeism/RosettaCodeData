/* HTTP hello server */
response.1 = 'HTTP/1.1 200 OK' || '0D0A'X,
          || 'Connection: close' || '0D0A'X,
          || 'Content-Type: text/html' || '0D0A0D0A'X
response.2 = '<!DOCTYPE html>' || '0A'X,
          || '<html><head><title>Hello, Rosetta</title></head>' || '0A'X,
          || '<body><h2>Goodbye, World!</h2></body>' || '0A'X,
          || '<!-- Shout out from the Rosetta Code programming chrestomathy --></html>' || '0A'X

DO FOREVER
    ADDRESS SYSTEM 'nc -l 8080' WITH INPUT STEM response.
END
