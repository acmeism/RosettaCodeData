 (let ((i 99))
	      (while (> i 0)
		(princ-list i " bottles of beer on the wall" "\n Take one down, pass it around")
		(setq i (1- i))))
