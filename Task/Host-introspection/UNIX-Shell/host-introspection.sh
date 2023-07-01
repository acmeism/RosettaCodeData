Aamrun$ getconf WORD_BIT
32
Aamrun$ echo -n I | od -to2 | awk 'FNR==1{ print substr($2,6,1)}'
1
Aamrun$
