(defun abbreviate-list (list-of-days abbreviation-length)
  "Take each element of LIST-OF-DAYS and abbreviate to ABBREVIATION-LENGTH."
  (let ((abbrev-list)
        (abbrev-element))
    (dolist (one-element list-of-days)                                        ; loop through each day of week
;; if the day of week is at least as long as the abbreviation
      (if (>= (length one-element) abbreviation-length)                       ; if day >= abbreviation length
          (setq abbrev-element (substring one-element 0 abbreviation-length)) ; abbreviate the day of the week
        (setq abbrev-element one-element))                                    ; otherwise don't abbreviate
      (push abbrev-element abbrev-list))                                      ; put the abbreviated/non-abbreviated day on our list
    abbrev-list))                                                             ; return the list of abbreviated days

(defun cycle-days (list-of-days)
  "Find shortest unique abbreviation in LIST-OF-DAYS list."
  (let ((abbrev-list)
        (abbrev-length 1)
        (current-abbrev)
        (looking-for-shortest-list t))
    (if (= (length list-of-days) 0)                                   ; if list-of-days is empty (i.e., blank line)
        (setq looking-for-shortest-list nil))                         ; then don't look for the shortest unique abbreviations
    (while looking-for-shortest-list                                  ; as long as we are looking for the shortest unique abbreviations
      (setq abbrev-list (abbreviate-list list-of-days abbrev-length)) ; get a list of abbreviated day names
      (if (= (length list-of-days) (length (seq-uniq abbrev-list)))   ; if abbreviated list has no duplicates
          (progn
            (message (format "%d %s" abbrev-length list-of-days))     ; then in echo buffer show length and days
            (setq looking-for-shortest-list nil))                     ; also, then don't look for the shortest unique abbreviations
        (setq abbrev-length (+ abbrev-length 1))))))                  ; else increase the length of the abbreviation; loop to while

(defun days-of-week ()
  "Find minimum abbreviation length of days of week."
  (let ((current-line-list))
  (find-file "Days_of_week.txt")                             ; open file or switch to buffer
  (beginning-of-buffer)                                      ; go to the top of the buffer
  (dolist (current-line (split-string (buffer-string) "\n")) ; go line by line through buffer
    (setq current-line-list (split-string current-line " ")) ; change each line into list of days of week
    (cycle-days current-line-list))))
