factor() {
  r=`echo "sqrt($1)" | bc` # or `echo $1 v p | dc`
  i=1
  while [ $i -lt $r ]; do
    if [ `expr $1 % $i` -eq 0 ]; then
      echo $i
      expr $1 / $i
    fi
    i=`expr $i + 1`
  done | sort -nu
}
