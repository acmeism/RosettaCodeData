"
ASCII code 	Symbols used
0 	|@
1 - 26 	|letter eg |A (or |a) = ASCII 1, |M (or |m) = ASCII 13
27 	|[ or |{
28 	|\
29 	|] or |}
30 	|^ or |~
31 	|_ or |' (grave accent)
32 - 126 	keyboard character, except for:
\" 	|\"
| 	||
< 	|<
127 	|?
128 - 255 	|!coded symbol eg ASCII 128 = |!|@ ASCII 129 = |!|A
"

(defun gst--load-char (encoded)
  (if (gst--is-end encoded)
      (error "Unexpected end.")
    (let ((c (aref (car encoded) (cadr encoded))))
      (setcdr encoded (list (1+ (cadr encoded))))
      c )))

(defun gst--is-end (lst)
  (>= (cadr lst) (length (car lst))))

(defun gst--translate-special (c)
  (cond
   ((eq c ?@) 0)
   ((eq c ?\[) 27)
   ((eq c ?\{) 27)
   ((eq c ?\\) 28)
   ((eq c ?\]) 29)
   ((eq c ?\}) 29)
   ((eq c ?^) 30)
   ((eq c ?~) 30)
   ((eq c ?_) 31)
   ((eq c ?') 31)
   ((eq c ?\") ?\")
   ((eq c ?|) ?|)
   ((eq c ?<) ?<)
   ((eq c ??) 127)
   ((and (>= c 65) (<= c 90)) (+ (- c 65) 1))
   ((and (>= c 97) (<= c 122)) (+ (- c 97) 1))
   (t nil)))

(defun gst--load-highpos-token (encoded)
  (let ((c (gst--load-char encoded)) sp)
    (cond
     ((eq c ?|)
      (setq sp (gst--load-char encoded))
      (+ 128 (gst--translate-special sp)))
     ((and (> c 31) (< c 127))
      (+ 128 c))
     (t (error "Not a printable character.")))))

(defun gst--load-token (encoded)
  (let ((c (gst--load-char encoded)) sp)
    (cond
     ((eq c ?|)
      (setq sp (gst--load-char encoded))
      (if (eq sp ?!)
	  (gst--load-highpos-token encoded)
	(gst--translate-special sp)))
     ((and (> c 31) (< c 127)) c)
     (t (error "Not a printable character.")))))

(defun gst-parse (text)
  (let ((encoded (list text 0)) (decoded '()))
    (while (not (gst--is-end encoded))
      (add-to-list 'decoded (gst--load-token encoded) 't))
    decoded))

(progn
  (let ((text "|LHello|G|J|M"))
    (message "%s => %s" text (gst-parse "|LHello|G|J|M"))))
