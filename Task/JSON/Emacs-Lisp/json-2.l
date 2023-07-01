(require 'json)

(defvar example "{\"foo\": \"bar\", \"baz\": [1, 2, 3]}")
(defvar example-object '((foo . "bar") (baz . [1 2 3])))

;; decoding
(json-read-from-string example) ;=> ((foo . "bar") (baz . [1 2 3]))
;; using plists for objects
(let ((json-object-type 'plist))
  (json-read-from-string)) ;=> (:foo "bar" :baz [1 2 3])
;; using hash tables for objects
(let ((json-object-type 'hash-table))
  (json-read-from-string example)) ;=> #<hash-table equal 2/65 0x1563c39805fb>

;; encoding
(json-encode example-object) ;=> "{\"foo\":\"bar\",\"baz\":[1,2,3]}"
;; pretty-printing
(let ((json-encoding-pretty-print t))
  (message "%s" (json-encode example-object)))
