url_decode()
{
        decode="${*//+/ }"
        eval print -r -- "\$'${decode//'%'@(??)/'\'x\1"'\$'"}'"  2>/dev/null
}

url_decode "http%3A%2F%2Ffoo%20bar%2F"
url_decode "google.com/search?q=%60Abdu%27l-Bah%C3%A1"
