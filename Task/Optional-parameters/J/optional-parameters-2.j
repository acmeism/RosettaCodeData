   ]Table=: ('a';'b';'c'),('';'q';'z'),:'zip';'zap';'Zot'
┌───┬───┬───┐
│a  │b  │c  │
├───┼───┼───┤
│   │q  │z  │
├───┼───┼───┤
│zip│zap│Zot│
└───┴───┴───┘
   srtbl Table           NB. default sort
┌───┬───┬───┐
│   │q  │z  │
├───┼───┼───┤
│a  │b  │c  │
├───┼───┼───┤
│zip│zap│Zot│
└───┴───┴───┘
   ]`1: srtbl Table      NB. sort by column 1
┌───┬───┬───┐
│a  │b  │c  │
├───┼───┼───┤
│   │q  │z  │
├───┼───┼───┤
│zip│zap│Zot│
└───┴───┴───┘
   ]`2:`1: srtbl Table   NB. reverse sort by column 2
┌───┬───┬───┐
│zip│zap│Zot│
├───┼───┼───┤
│   │q  │z  │
├───┼───┼───┤
│a  │b  │c  │
└───┴───┴───┘
   #&>`0: srtbl Table    NB. sort by length
┌───┬───┬───┐
│   │q  │z  │
├───┼───┼───┤
│a  │b  │c  │
├───┼───┼───┤
│zip│zap│Zot│
└───┴───┴───┘
