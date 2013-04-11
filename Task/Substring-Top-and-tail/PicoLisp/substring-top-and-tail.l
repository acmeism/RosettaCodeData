: (pack (cdr (chop "knight")))         # Remove first character
-> "night"

: (pack (head -1 (chop "socks")))      # Remove last character
-> "sock"

: (pack (cddr (rot (chop "brooms"))))  # Remove first and last characters
-> "room"
