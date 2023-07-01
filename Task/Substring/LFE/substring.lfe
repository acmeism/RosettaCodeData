> (set n 3)
3
> (set m 5)
5
> (string:sub_string "abcdefghijklm" n)
"cdefghijklm"
> (string:sub_string "abcdefghijklm" n (+ n m -1))
"cdefg"
> (string:sub_string "abcdefghijklm" 1 (- (length "abcdefghijklm") 1))
"abcdefghijkl"
> (set char-index (string:chr "abcdefghijklm" #\e))
5
> (string:sub_string "abcdefghijklm" char-index (+ char-index m -1))
"efghi"
> (set start-str (string:str "abcdefghijklm" "efg"))
5
> (string:sub_string "abcdefghijklm" start-str (+ start-str m -1))
"efghi"
