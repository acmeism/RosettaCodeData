str="abc qrdef qrghi"
n=6
m=3

expr "x$str" : "x.\{$n\}\(.\{1,$m\}\)"
expr "x$str" : "x.\{$n\}\(.*\)"
printf '%s\n' "${str%?}"
expr "r${str#*r}" : "\(.\{1,$m\}\)"
expr "qr${str#*qr}" : "\(.\{1,$m\}\)"
