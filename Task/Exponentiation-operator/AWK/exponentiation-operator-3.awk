And if you want to use locales for decimal separator, you have tu use -N option :
$ gawk -N '{ printf("%f\n",$1^$2) }'
