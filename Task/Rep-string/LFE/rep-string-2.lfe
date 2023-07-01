(defun report
  ((`#(,text ()))
   (io:format "~p has no repeating characters.~n" `(,text)))
  ((`#(,text (,head . ,_)))
   (io:format "~p repeats ~p every ~p character(s).~n" `(,text ,head ,(length head))))
  ((data)
   (lists:map
    #'report/1
    (lists:zip data (lists:map #'get-reps/1 data)))
   'ok))
