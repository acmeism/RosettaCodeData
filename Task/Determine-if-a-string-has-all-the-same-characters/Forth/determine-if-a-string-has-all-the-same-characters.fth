: samechars? ( str-addr str-len -- )
   [char] " emit 2dup type [char] " emit ."  length: " dup . ." -> "
   dup 1 > if
      over c@ swap 1 do
         over i + c@ over <> if
            ." different character '" drop i + c@ dup emit
            ." ' ($" hex 1 .r ." ) at " decimal i . cr unloop exit
         then
      loop
   then 2drop ." all characters are the same" cr ;

s" " samechars?
s"    " samechars?
s" 2" samechars?
s" 333" samechars?
s" .55" samechars?
s" tttTTT" samechars?
s" 4444 444k" samechars?
