function bin {
    typeset -i2 n=$1
    print -r -- "${n#2#}"
}

print -r -- $(for i in 0 1 2 5 50 9000; do bin "$i"; done)
