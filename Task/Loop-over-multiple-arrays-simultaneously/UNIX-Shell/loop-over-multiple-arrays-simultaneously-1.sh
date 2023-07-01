a=a:b:c
b=A:B:C
c=1:2:3

oldifs=$IFS
IFS=:
i=0
for wa in $a; do
	set -- $b; shift $i; wb=$1
	set -- $c; shift $i; wc=$1

	printf '%s%s%s\n' $wa $wb $wc

	i=`expr $i + 1`
done
IFS=$oldifs
