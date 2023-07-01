Red []
;; read and convert data to a string - to char conversion is neccessary to avoid
;; illegal utf8 encoding error....

data: collect/into [foreach b read/binary %abbrev.txt [keep to-char b ]] ""
                                           ;; data: read %abbrev.txt - would work, if file was utf-8 encoded ...
foreach line split data newline [           ;; split data in lines at carriage return & line feed:

 if  empty?  trim line [ continue ]         ;; continues at head of loop

 arr: split line space                      ;; now split line in words ; accumulate in array / series

 min: 1                                     ;; preset min length
 until [
                                            ;; head is the first position of series
   if head? arr [m: make map! [] ]          ;; define an empty map (key -value store)

   abbr: copy/part first arr min            ;; copy/part ~  leftstr of first word with length min

   arr: either m/:abbr [                    ;; abbreviation already exists ?
        min: min + 1
        head arr                            ;; reset series position to head
      ][                                    ;; otherwise ....
        m/:abbr: true                       ;; mark abreviation in map as existent
        next arr                            ;; set series position to next word
      ]
  tail? arr                                 ;; this is the until condition , end /tail of  series reached ?
 ]
 print [min line]                           ;; print automatically reduces all words in block
]
