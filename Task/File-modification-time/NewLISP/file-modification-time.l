;; print modification time
(println (date (file-info "input.txt" 6)))

;; set modification time to now (Unix)
(! "touch -m input.txt")
