reprint() {
  typeset e="$(sed -e 's,%,%%,g' -e 's,\\,\\\\,g' <<<"$1")"
  eval 'printf "$e"%.0s '"{1..$2}"
}
reprint '%  ha  \' 5
