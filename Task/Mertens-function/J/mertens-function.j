mu    =: 0:`(1 - 2 * 2|#@{.)@.(1: = */@{:)@(2&p:)"0
M     =: +/@([: mu 1:+i.)

m1000 =: (M"0) 1+i.1000
zero  =: +/ m1000 = 0
cross =: +/ (-.*.1:|]) m1000 ~: 0

echo 'The first 99 Merten numbers are'
echo 10 10$ __, 99{.m1000
echo 'M(N) is zero ',(":zero),' times.'
echo 'M(N) crosses zero ',(":cross),' times.'
exit''
