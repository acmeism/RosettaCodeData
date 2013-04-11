uniq() {
  u=("$@")
  for ((i=0;i<${#u[@]};i++)); do
    for ((j=i+1;j<=${#u[@]};j++)); do
      [ "${u[$i]}" = "${u[$j]}" ] && unset u[$i]
    done
  done
  u=("${u[@]}")
}

a=(John Serena Bob Mary Serena)
b=(Jim Mary John Jim Bob)

uniq "${a[@]}"
au=("${u[@]}")
uniq "${b[@]}"
bu=("${u[@]}")

ab=("${au[@]}")
for ((i=0;i<=${#au[@]};i++)); do
  for ((j=0;j<=${#bu[@]};j++)); do
    [ "${ab[$i]}" = "${bu[$j]}" ] && unset ab[$i]
  done
done
ab=("${ab[@]}")

ba=("${bu[@]}")
for ((i=0;i<=${#bu[@]};i++)); do
  for ((j=0;j<=${#au[@]};j++)); do
    [ "${ba[$i]}" = "${au[$j]}" ] && unset ba[$i]
  done
done
ba=("${ba[@]}")

sd=("${ab[@]}" "${ba[@]}")

echo "Set A = ${a[@]}"
echo "      = ${au[@]}"
echo "Set B = ${b[@]}"
echo "      = ${bu[@]}"
echo "A - B = ${ab[@]}"
echo "B - A = ${ba[@]}"
echo "Symmetric difference = ${sd[@]}"
