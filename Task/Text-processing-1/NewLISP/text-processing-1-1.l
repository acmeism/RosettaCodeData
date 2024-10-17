(let (handle (open "readings.txt" "read"))
  (setq all-lines (collect (read-line handle)))
  (close handle))
