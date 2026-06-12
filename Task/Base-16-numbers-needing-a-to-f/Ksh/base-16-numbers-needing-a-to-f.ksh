typeset -i10 n

for n in '16#'{,1}{{0..9}{a..f},{a..f}{{0..9},{a..f}}}
do
    ((n < 501)) || break
    print -n -r -- " $n"
done
print
