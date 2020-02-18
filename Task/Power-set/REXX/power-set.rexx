/*REXX program  displays a  power set;  items may be  anything  (but can't have blanks).*/
parse arg S                                      /*allow the user specify optional set. */
if S=''  then S= 'one two three four'            /*Not specified?  Then use the default.*/
@= '{}'                                          /*start process with a null power set. */
N= words(S);     do chunk=1  for N               /*traipse through the items in the set.*/
                 @=@  combN(N, chunk)            /*take  N  items, a  CHUNK  at a time. */
                 end    /*chunk*/
w= length(2**N)                                  /*the number of items in the power set.*/
                 do k=1  for words(@)            /* [↓]  show combinations,  1 per line.*/
                 say right(k, w)     word(@, k)  /*display a single combination to term.*/
                 end    /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
combN:  procedure expose S;  parse arg x,y;     base= x + 1;           bbase= base - y
        !.= 0
                        do p=1  for y;          !.p= p
                        end   /*p*/
        $=
                        do j=1;       L=;       do d=1  for y;         L= L','word(S, !.d)
                                                end   /*d*/
                        $=$  '{'strip(L, "L", ',')"}";                 !.y= !.y + 1
                        if !.y==base  then  if .combU(y - 1)  then leave
                        end   /*j*/
        return strip($)                          /*return with a partial power set chunk*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
.combU: procedure expose !. y bbase;        parse arg d;           if d==0  then return 1
        p= !.d
                  do u=d  to y;   !.u= p + 1;     if !.u==bbase+u  then return .combU(u-1)
                  p= !.u
                  end   /*u*/
        return 0
