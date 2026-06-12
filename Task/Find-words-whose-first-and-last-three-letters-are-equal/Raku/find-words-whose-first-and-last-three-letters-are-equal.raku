# 20210210 Raku programming solution

my ( \L, \N, \IN ) = 5, 3, 'unixdict.txt';

for IN.IO.lines { .say if .chars > L and .substr(0,N) eq .substr(*-N,*) }
