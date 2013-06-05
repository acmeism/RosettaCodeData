#lang racket
(require openssl/sha1)
(sha1 (open-input-string "Rosetta Code"))
