(format t "~C[?1049h~C[H" (code-char #O33) (code-char #O33))
(format t "Alternate screen buffer~%")
(loop for i from 5 downto 1 do (progn
                             (format t "~%going back in ~a" i)
                             (sleep 1)
                             ))
(format t "~C[?1049l" (code-char #O33))
