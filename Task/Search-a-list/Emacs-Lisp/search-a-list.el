(defun get-index (item list)
  "Return index of first ITEM in LIST.
Display error message if ITEM is not
part of LIST."
  (if (seq-position list item) ; if it's in LIST
      (seq-position list item) ; return index
    ;; else, provide an error message
    (message "%s is not an element in %s." item list)))

;; My thanks to Protesileos Stavrou (aka "Prot") for
;; key ideas for the section below, including reversing
;; the list in order to easily find the last item in it.
(defun last-position (item list)
  "Return last ITEM index in LIST."
  ;; test if ITEM is in LIST
  (if (seq-position list item) ; if it's in LIST
      (progn
        ;; subtract the adjusted length of the list from
        ;; the position of ITEM in the reverse of LIST
        (-
         ;; 1- corrects for length being 1 based, but seq-position is 0 based
         (1- (length list))
         ;; reverse list because
         ;; seq-position searches from beginning of list
         (seq-position (nreverse list) item)))
    (message "%s is not an element in %s." item list)))
