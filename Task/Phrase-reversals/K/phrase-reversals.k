/ Rosetta code phrase reversal
/ phraserev.k

reversestr: {|x}
getnxtwd: {c:(&" "~'x); if[c~!0;w::x;:""];w::c[0]#x; x: ((1+c[0]) _ x)}
revwords: {rw:""; while[~(x~""); x: getnxtwd x;rw,:|w;rw,:" "];:-1 _ rw}
revwordorder: {rw:""; while[~(x~""); x: getnxtwd x;rw:" ",rw;rw:w,rw];:-1 _ rw}
