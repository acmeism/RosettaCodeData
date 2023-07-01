require'convert/misc/vig convert/misc/ascii85'
randseq=: {{ 2!:0'dd 2>/dev/null if=/dev/urandom count=1 bs=',":y }}
genpad=: {{ EMPTY [ (randseq y) fwrite x }}
encrypt=: {{ toascii85 (fread x) 0 vig a. y }}
decrypt=: {{ (fread x) 1 vig a. fromascii85 y }}
