#lang racket
(require file/sha1)

(sha1 (open-input-string "Rosetta Code"))
