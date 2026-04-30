(defun bm_compile_pattern (pattern)
  "Compile the pattern to a right most position map"
  (let ((patLen (length pattern))
        (rightMap (make-vector 256 -1))
        (j -1))
    (while (> patLen (setq j (1+ j)))
      (aset rightMap (elt pattern j) j) )
    rightMap
    )
  )
;;
(defun bm_make_suffix_table (text)
  (let ((suffix-table (make-vector (length text) -1)) (textLen (length text))
	(suffix-found nil)
	)
    (cl-loop for pos from (1- textLen) downto 1 do
	     (setq suffix-found nil)
	     (cl-loop for ptn from (- textLen 2) downto 0 while (not suffix-found) do
		      (let ((start1 pos) (end1 (1- textLen))
			    (start2 (- ptn (- (1- textLen) pos))) (end2 ptn)
			    (matched 't)
			    )
			(if (< start2 0) (setq start2 0))
			(cl-loop for idx1 from end1 downto start1 and idx2 from end2 downto start2 while matched do
				 (if (/= (elt text idx1) (elt text idx2))
				     (setq matched nil))
				 )
			(when matched
			  (aset suffix-table pos start2)
			  (setq suffix-found 't) )
			)
		      )
	     )
    suffix-table
    )
  )
;;
;;
(defun bm_substring_search (pattern text)
  "Boyer-Moore string search"
  (let ((patLen (length pattern))
        (txtLen (length text))
        (startPos 0)
        (result nil)
        (rightMap (bm_compile_pattern pattern))
	(suffixTable (bm_make_suffix_table pattern)))
    ;; Continue this loop when no result and not exceed the text length
    (while (and (not result) (<= (+ startPos patLen) txtLen))

      (let ((idx patLen)
	    (suffixSkip 0)
	    (badCharSkip 0)
            (skip 0))
        (while (and (= 0 skip) (<= 0 (setq idx (1- idx))))
	  (setq suffixSkip 0)
	  (setq badCharSkip 0)
          ;; skip when the character at position idx is different
          (when (/= (elt pattern idx) (elt text (+ startPos idx)))
	    (when (< idx (1- (length pattern)))
	      (setq suffixSkip (aref suffixTable (1+ idx))) )
	    (setq badCharSkip (- idx (aref rightMap (elt text (+ startPos idx)))))
            ;; looking up the right most position in pattern
	
            (setq skip (max 1 badCharSkip suffixSkip))
            )
          )
        (if (< 0 skip)
            (setq startPos (+ startPos skip))
          (setq result startPos)
          )
        )
      )
    result
    )
  )
;;
(let ((pattern "alfalfa")
      (full_text "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."))
  (bm_substring_search pattern full_text) )

)
