(function check-all-chars-same string
  (print "String (" string ") of len: " (len string))
  (let num-same (count-while (= (0 string)) string))
  (return-when (= num-same (len string))
    (print "...all characters the same"))
  (print (pad-left " " (+ 9 num-same) "^"))
  (print "...character " num-same " differs - it is 0x"
    (to-base 16 (char-code (num-same string)))))

(map check-all-chars-same ["" "   " "2" "333" ".55" "tttTTT" "4444 444k"])
