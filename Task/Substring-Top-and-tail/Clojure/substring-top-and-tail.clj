; using substring:
user=> (subs "knight" 1)
"night"
user=> (subs "socks" 0 4)
"sock"
user=> (.substring "brooms" 1 5)
"room"

; using rest and drop-last:
user=> (apply str (rest "knight"))
"night"
user=> (apply str (drop-last "socks"))
"sock"
user=> (apply str (rest (drop-last "brooms")))
"room"
