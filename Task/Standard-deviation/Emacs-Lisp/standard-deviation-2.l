(with-temp-buffer
  (loop for i in '(2 4 4 4 5 5 7 9) do
        (insert (number-to-string (running-std i)))
        (newline))
  (message (buffer-substring (point-min) (1- (point-max)))))

"0.0
1.0
0.9428090415820636
0.8660254037844386
0.9797958971132716
1.0
1.399708424447531
2.0"
