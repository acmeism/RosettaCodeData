(use http-client)
(print
  (with-input-from-request "http://google.com/"
                           #f read-string))
