> (set split (string:tokens "Hello,How,Are,You,Today" ","))
("Hello" "How" "Are" "You" "Today")
> (string:join split ".")
"Hello.How.Are.You.Today"
