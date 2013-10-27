(let ((seconds (read-number "Time in seconds: ")))
  (message "Sleeping ...")
  (sleep-for seconds)
  (message "Awake!"))
