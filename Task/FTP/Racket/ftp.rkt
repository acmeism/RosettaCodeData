#lang racket
(require net/ftp)
(let* ([server "kernel.org"]
       [remote-dir "/pub/linux/kernel/"]
       [conn (ftp-establish-connection
               server
               21
               "anonymous"
               "")])
  (ftp-cd conn remote-dir)
  (map
   (lambda (elem) (displayln (string-join elem "\t")))
   (ftp-directory-list conn "."))
  (ftp-download-file conn "." "README")
  (ftp-close-connection conn))
