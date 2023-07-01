(prin "abc")
(call "tput" "rev")
(prin "def")  # These three chars are displayed in reverse video
(call "tput" "sgr0")
(prinl "ghi")
