Red []
;; code to read url and save to local file:
;;data: read/binary http://www.puzzlers.org/pub/wordlists/unixdict.txt
;;write %unixdict.txt data

max: [ "" ] ;; init array with one empty string (length 0 )

foreach word read/lines %unixdict.txt [   ;; read local file
  len: either  word = sort copy word [ length? word ] [  -1 ]   ;; check if ordered and get length
  case [
    len  > length?  first max [    max:  reduce [ word ]]       ;; init new block
    len = length? first max   [ append max word   ]
  ]
]
probe max
