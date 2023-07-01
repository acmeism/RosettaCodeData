(tagbody
  beginning
    (format t "I am in the beginning~%")
    (sleep 1)
    (go end)
  middle
    (format t "I am in the middle~%")
    (sleep 1)
    (go beginning)
  end
    (format t "I am in the end~%")
    (sleep 1)
    (go middle))
