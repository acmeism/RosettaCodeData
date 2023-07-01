(lists:zipwith3
  (lambda (i j k)
    (io:format "~s~s~p~n" `(,i ,j ,k)))
    '(a b c)
    '(A B C)
    '(1 2 3))
