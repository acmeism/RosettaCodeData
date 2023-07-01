(url-retrieve "http://www.rosettacode.org"
              (lambda (_status)
                (message "%s" (buffer-substring url-http-end-of-headers (point-max)))))
