use=: 'Use: ', (;:inv 2 {. ARGV) , ' YYYY-MM-DD YYYY-MM-DD'

3 :0 ::echo use
 TAU=: 2p1  NB. tauday.com

 require'plot ~addons/types/datetime/datetime.ijs'

 span=: (i.7) + daysDiff&(1 0 0 0 1 0 1 0 ".;.1 -.&'-')~
 Length=: 23 5 p. i. 3
 arg=: Length *inv TAU * Length |/ span
 brtable=: 1 o. arg
 biorhythm=: 'title biorythms for the week ahead; key Physical Emotional Mental' plot (i.7) (j."1) brtable~
 biorhythm/ 2 3 {::"0 1 ARGV
 echo 'find new graph (plot.pdf) in directory ' , jpath '~temp/'

 brs=. brtable/ 2 3 {::"0 1 ARGV
 echo (a:,'values';'interpretation') ,: (4 10 $ 'days aheadPhysical  Emotional Mental     ') ; (1 3 # 6 6j1)&(":"0 1) L:0 (; |) brs ,~ i. 7
)

exit 0
