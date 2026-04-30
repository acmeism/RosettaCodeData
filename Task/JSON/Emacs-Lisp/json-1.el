(require 'cl-lib)

(cl-assert (fboundp 'json-parse-string))
(cl-assert (fboundp 'json-serialize))

(defvar example "{\"foo\": \"bar\", \"baz\": [1, 2, 3]}")
(defvar example-object '((foo . "bar") (baz . [1 2 3])))

;; decoding
(json-parse-string example) ;=> #s(hash-table [...]))
;; using json.el-style options
(json-parse-string example :object-type 'alist :null-object nil :false-object :json-false)
;;=> ((foo . "bar") (baz . [1 2 3]))
;; using plists for objects
(json-parse-string example :object-type 'plist) ;=> (:foo "bar" :baz [1 2 3])

;; encoding
(json-serialize example-object) ;=> "{\"foo\":\"bar\",\"baz\":[1,2,3]}"
