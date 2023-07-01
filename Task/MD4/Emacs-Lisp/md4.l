(require 'md4)
(require 'hex-util)
(let* ((s  "Rosetta Code")
       (m  (md4 s (length s)))) ;; m = 16 binary bytes
  (encode-hex-string m))
=>
"a52bcfc6a0d0d300cdc5ddbfbefe478b"
