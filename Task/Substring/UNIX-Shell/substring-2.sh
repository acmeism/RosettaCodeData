str="abc qrdef qrghi"
n=6
m=3

expr "x$str" : "x.\{$n\}\(.\{1,$m\}\)"
expr "x$str" : "x.\{$n\}\(.*\)"
expr "x$str" : "x\(.*\)."

index() {
	i=0 s=$1
	until test "x$s" = x || expr "x$s" : "x$2" >/dev/null; do
		i=`expr $i + 1` s=`expr "x$s" : "x.\(.*\)"`
	done
	echo $i
}
expr "x$str" : "x.\{`index "$str" r`\}\(.\{1,$m\}\)"
expr "x$str" : "x.\{`index "$str" qr`\}\(.\{1,$m\}\)"
