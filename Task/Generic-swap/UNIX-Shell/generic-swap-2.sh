$ swap() { local var1=$1 var2=$2; set -- "${!var1}" "${!var2}"; declare -g "$var1"="$2" "$var2"="$1"; }
$ a=1 b=2
$ echo $a $b
1 2
$ swap a b
$ echo $a $b
2 1
$ swap a b
$ echo $a $b
1 2
