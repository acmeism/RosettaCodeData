(dolist (lst '((-2  2  1 "Normal")	  ; Iterate the parameters list `start' `stop' `increment' and `comment'
	       (-2  2  0 "Zero increment")
	       (-2  2 -1 "Increments away from stop value")
	       (-2  2 10 "First increment is beyond stop value")
	       ( 2 -2  1 "Start more than stop: positive increment")
	       ( 2  2  1 "Start equal stop: positive increment")
	       ( 2  2 -1 "Start equal stop: negative increment")
	       ( 2  2  0 "Start equal stop: zero increment")
	       ( 0  0  0 "Start equal stop equal zero: zero increment")))
  (do ((i (car lst) (incf i (caddr lst))) ; Initialize `start' and set `increment'
       (result ())			  ; Initialize the result list
       (loop-max 0 (incf loop-max)))	  ; Initialize a loop limit
      ((or (> i (cadr lst))		  ; Break condition to `stop'
	   (> loop-max 10))		  ; Break condition to loop limit
       (format t "~&~44a: ~{~3d ~}"	  ; Finally print
	       (cadddr lst)		  ; The `comment'
	       (reverse result)))	  ; The in(de)creased numbers into result
    (push i result)))			  ; Add the number to result
