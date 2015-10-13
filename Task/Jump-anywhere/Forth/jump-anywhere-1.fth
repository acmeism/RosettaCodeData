0 value goto1 0 value goto2 0 value goto3 0 value goto4 0 value goto5
0 value goto6 0 value goto7 0 value goto8 0 value goto9 0 value goto10

: proc1
[ here to goto1 ] s" line1 " type goto7 >r exit
[ here to goto2 ] s" line2 " type goto8 >r exit
[ here to goto3 ] s" line3 " type goto9 >r exit
[ here to goto4 ] s" line4 " type goto10 >r exit
[ here to goto5 ] s" line5" type cr ;

: proc2
[ here to goto6 ] s" line6 " type goto1 >r exit
[ here to goto7 ] s" line7 " type goto2 >r exit
[ here to goto8 ] s" line8 " type goto3 >r exit
[ here to goto9 ] s" line9 " type goto4 >r exit
[ here to goto10 ] s" line10 " type goto5 >r ;

proc2
bye
