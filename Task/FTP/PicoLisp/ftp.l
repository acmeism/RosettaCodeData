(in '(curl "-sl" "ftp://kernel.org/pub/site/")
   (while (line)
      (prinl @) ) )
(call "curl" "-s" "-o" "sha256sums.asc" "ftp://kernel.org/pub/site/sha256sums.asc")
