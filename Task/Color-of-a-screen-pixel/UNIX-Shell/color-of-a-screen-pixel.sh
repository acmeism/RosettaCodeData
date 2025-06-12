spectacle -nbo /dev/stdout 2>/dev/null | magick - txt:- | grep "^0,0" | awk '{ print $2 }'
