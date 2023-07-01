(defun pturn (curTokens)
	(write-string "How many tokens would you like to take?: ")
	(setq ans (read))
	(setq tokensRemaining (- curTokens ans))
	(format t "You take ~D tokens~%" ans)
	(printRemaining tokensRemaining)
	tokensRemaining)

(defun cturn (curTokens)
	(setq take (mod curTokens 4))
	(setq tokensRemaining (- curTokens take))
	(format t "Computer takes ~D tokens~%" take)
	(printRemaining tokensRemaining)
	tokensRemaining)

(defun printRemaining (remaining)
	(format t "~D tokens remaining~%~%" remaining))


(format t "LISP Nim~%~%")
(setq tok 12)
(loop
	(setq tok (pturn tok))
	(setq tok (cturn tok))
	(if (<= tok 0)
		(return)))
(write-string "Computer wins!")
