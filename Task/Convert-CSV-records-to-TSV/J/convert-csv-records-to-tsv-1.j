tokenize=: (0;(0 10#:10*do@>cutLF{{)n
    1.1 1.1 1.1 1.1 1.1 NB. 0  start here
    1.2 2.0 3.2 1.2 1.0 NB. 1  , or CR or LF starts a new "token"
    2   4   2   2   2   NB. 2  quote toggles "quoted field mode"
    1.2 2.0 1.0 2.2 1.0 NB. 3  CR,LF: 1 "token"  CR,CR and CR,',': 2 "tokens"
    1.2 2.0 3.2 1.2 5.3 NB. 4  closing quote must be followed by a delimiter
    5   5   1.1 1.1 5   NB. 5  resync on newline after encountering nonsense
}});(;/',"',LF,CR);0 _1 0 _1) ;: LF,]
NB. ,   "   CR  LF  ...

unquote=: {{
  txt=. (1+CRLF-:2{.y)}.y  NB. discard leading ',', LF, CR or CRLF
  if. '"'={.txt do.
    rplc&('""';'"') }. txt}.~-'"'={:txt
  else.
    txt
  end.
}}

NUL=: 0{a.

canonical=: {{ NB. read if file and drop optional trailing newline
  txt=. fread^:L. y
  txt}.~-(CRLF-:_2{.txt)+({:txt)e.CRLF
}}

csv2mat=: (e.&CRLF@{.@> unquote each;.1 ])@tokenize@canonical

escape=: rplc&('\';'\\';NUL;'\0';TAB;'\t';LF;'\n';CR;'\r')@":

mat2tsv=: {{ ;LF,~each ([,TAB,])each/"1 escape each y }}

csv2tsv=: mat2tsv@csv2mat
