Red []
s: copy ""   ;; assign empty string
?? s
if empty? s [print "string is empty "]          ;; check if string is empty
s: "abc"
prin s unless empty? s  [print " not empty"]
