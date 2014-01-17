(require 'md4)
(let* ((s  "Rosetta Code")
       (m  (md4 s (length s)))) ;; m = 16 binary bytes
  (require 'hex-util)
  (encode-hex-string m))
=>
"a52bcfc6a0d0d300cdc5ddbfbefe478b"
