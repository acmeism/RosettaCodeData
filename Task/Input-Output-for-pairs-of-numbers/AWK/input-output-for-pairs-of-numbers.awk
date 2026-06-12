NR == 1 {n=$1; next}
NR > n+1 {exit}
{print $1+$2}
