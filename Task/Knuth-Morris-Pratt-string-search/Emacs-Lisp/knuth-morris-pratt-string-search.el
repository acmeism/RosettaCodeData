(defun kmp_compile_pattern (pattern)
  "Compile pattern to DFA."

  (defun create-2d-array (x y init)
    (let ((arr1 (make-vector x nil)))
      (dotimes (i x)
	(aset arr1 i (make-vector y init)) )
      arr1 ) )

  (let* ((patLen (length pattern))
	 (R 256)
         (restartPos 0)
	 (dfa (create-2d-array R patLen 0)))

    (aset (aref dfa (elt pattern 0)) 0 1)

    (let ((patPos 0))
      (while (progn (setq patPos (1+ patPos)) (< patPos patLen))
	(dotimes (c R)
	  (aset (aref dfa c) patPos (aref (aref dfa c) restartPos)) )
	
	(aset (aref dfa (elt pattern patPos)) patPos (1+ patPos))
	(setq restartPos
	      (aref (aref dfa (elt pattern patPos)) restartPos) )
	)
      )
    dfa )
  )

(defun kmp_search (pattern text)
  "Pattern search with KMP algorithm."
  (let ((dfa (kmp_compile_pattern pattern)))

    (let ((textPos 0) (patPos 0) (N (length text)) (M (length pattern)))
      (while (and (< textPos N) (< patPos M))
	(setq patPos (aref (aref dfa (elt text textPos)) patPos))
	(setq textPos (1+ textPos)) )

      (if (= patPos M) (- textPos M) N ) ) ) )
