if [ $# -lt 2 ]; then
  set ${1-100} 25 10 5 1
fi
amount=$1
shift
ways_0=1
for coin in "$@"; do
  j=$coin
  while [ $j -le $amount ]; do
    d=`expr $j - $coin`
    eval "ways_$j=\`expr \${ways_$j-0} + \${ways_$d-0}\`"
    j=`expr $j + 1`
  done
done
eval "echo \$ways_$amount"
