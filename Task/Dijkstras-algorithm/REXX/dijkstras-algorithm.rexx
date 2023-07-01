/*REXX program determines the  least costly path  between  two vertices  given a list.  */
$.= copies(9, digits() )                         /*edge cost:  indicates doesn't exist. */
xList= '!. @. $. beg fin bestP best$ xx yy'      /*common  EXPOSEd  variables for subs. */
@abc=  'abcdefghijklmnopqrstuvwxyz'              /*list of all the possible vertices.   */
verts= 0;  edges= 0                              /*the number of vertices and also edges*/
                      do #=1  for length(@abc);              _= substr(@abc, #, 1)
                      call value translate(_), #;      @@.#= _
                      end   /*#*/
call def$  a  b   7                              /*define an  edge  and  its  cost.     */
call def$  a  c   9                              /*   "    "    "    "    "     "       */
call def$  a  f  14                              /*   "    "    "    "    "     "       */
call def$  b  c  10                              /*   "    "    "    "    "     "       */
call def$  b  d  15                              /*   "    "    "    "    "     "       */
call def$  c  d  11                              /*   "    "    "    "    "     "       */
call def$  c  f   2                              /*   "    "    "    "    "     "       */
call def$  d  e   6                              /*   "    "    "    "    "     "       */
call def$  e  f   9                              /*   "    "    "    "    "     "       */
beg= a;    fin= e                                /*the  BEGin  and  FINish  vertexes.   */
say;       say 'number of    edges = '   edges
           say 'number of vertices = '   verts                 "    ["left(@abc, verts)"]"
best$= $.;    bestP=
say;                         do jv=2  to verts;    call paths verts, jv;       end  /*jv*/
@costIs= right('cost =', 16)
if bestP==$.  then say 'no path found.'
              else say 'best path ='   translate(bestP, @abc, 123456789)   @costIs   best$
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
apath: parse arg pathx 1 p1 2 p2 3;             Lp= length(pathx);              $= $.p1.p2
       if $>=best$  then return
       pv= p2;                      do ka=3  to Lp;   _= substr(pathx, ka, 1)
                                    if $.pv._>=best$  then return
                                    $= $ + $.pv._;    if $>=best$  then return;      pv= _
                                    end   /*ka*/
       best$= $;    bestP= pathx
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
def$:  parse arg xx yy $ .;         if $.xx.yy<$  &  $.yy.xx<$  |  xx==yy  then return
       edges= edges + 1;            verts= verts  +  ($.xx\==0)  +  ($.yy\==0)
       $.xx= 0;        $.yy= 0;     $.xx.yy= $
       say left('', 40)     "cost of    "     @@.xx     '───►'     @@.yy     "   is "    $
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
paths: procedure expose (xList);    parse arg xx, yy, @.
                     do kp=1  for xx;     _= kp;   !.kp= _;   end   /*build a path list.*/
       call .path 1
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.path: procedure expose (xList);    parse arg ?, _
       if ?>yy  then do;            if @.1\==beg | @.yy\==fin  then return
                       do #=1  for yy;  _= _ || @.#;  end  /*#*/;             call apath _
                     end
                else do qq=1  for xx                    /*build vertex paths recursively*/
                       do kp=1  for ?-1;  if @.kp==!.qq  then iterate qq;  end  /*kp*/
                     @.?= !.qq;     call .path ?+1      /*recursive call for next path. */
                     end   /*qq*/
       return
