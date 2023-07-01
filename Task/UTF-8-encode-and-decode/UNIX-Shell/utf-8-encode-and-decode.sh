function encode {
    typeset -i code_point=$1
    printf "$(printf '\\U%08X\\n' "$code_point")"
}
function decode {
    typeset character=$1
    printf 'U+%04X\n' "'$character"
    set +x
}
printf 'Char\tCode Point\tUTF-8 Bytes\n'
for test in A ö Ж € 𝄞; do
    code_point=$(decode "$test")
    utf8=$(encode "$(( 16#${code_point#U+} ))")
    bytes=$(printf '%b' "$utf8" | od -An -tx1 | sed -nE '/./s/^  *|  *$//p')
    printf '%-4b\t%-10s\t%s\n' "$utf8" "$code_point" "$bytes"
done
