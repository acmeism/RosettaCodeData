If you want to use arbitrary precision number with (more recent) awk, you have to use -M option :
$ gawk -M '{ printf("%f\n",$1^$2) }'
