width=72; char='='
head -c ${width} < /dev/zero | tr '\0' "$char"
