(import http-client (chicken io))
(define api-root "http://api.macvendors.com")
(define mac-addresses '("88:53:2E:67:07:BE" "D4:F4:6F:C9:EF:8D"
                        "FC:FB:FB:01:FA:21" "4c:72:b9:56:fe:bc"
                        "00-14-22-01-23-45"))

(define get-vendor (lambda (mac-address)
  (with-input-from-request (string-append api-root "/" mac-address)
      #f read-string)))

(display (get-vendor (car mac-addresses)))
(newline)
(map (lambda (burger) (sleep 2) (display (get-vendor burger)) (newline))
     (cdr mac-addresses))
