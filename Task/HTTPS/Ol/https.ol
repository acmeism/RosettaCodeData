(import (lib curl))

(define curl (make-curl))
(curl 'url "https://www.w3.org/")
(curl 'perform)
