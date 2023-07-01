/*REXX program uses Floyd─Warshall algorithm to find shortest distance between vertices.*/
v= 4             /*███       {1}       ███*/     /*number of vertices in weighted graph.*/
@.= 99999999     /*███    4 /   \ -2   ███*/     /*the default distance  (edge weight). */
@.1.3= -2        /*███     /  3  \     ███*/     /*the distance (weight) for an edge.   */
@.2.1=  4        /*███  {2} ────► {3}  ███*/     /* "     "         "     "   "   "     */
@.2.3=  3        /*███     \     /     ███*/     /* "     "         "     "   "   "     */
@.3.4=  2        /*███   -1 \   / 2    ███*/     /* "     "         "     "   "   "     */
@.4.2= -1        /*███       {4}       ███*/     /* "     "         "     "   "   "     */

            do     k=1  for v
              do   i=1  for v
                do j=1  for v;  _= @.i.k + @.k.j /*add two nodes together.              */
                if @.i.j>_  then @.i.j= _        /*use a new distance (weight) for edge.*/
                end   /*j*/
              end     /*i*/
            end       /*k*/
w= 12;                     $= left('', 20)       /*width of the columns for the output. */
say $ center('vertices',w) center('distance', w) /*display the  1st  line of the title. */
say $ center('pair'    ,w) center('(weight)', w) /*   "     "   2nd    "   "  "    "    */
say $ copies('═'       ,w) copies('═'       , w) /*   "     "   3rd    "   "  "    "    */
                                                 /* [↓]  display edge distances (weight)*/
   do   f=1  for v                               /*process each of the "from" vertices. */
     do t=1  for v;    if f==t  then iterate     /*   "      "   "  "   "to"      "     */
     say  $      center(f '───►' t, w)        right(@.f.t, w % 2)
     end   /*t*/                                 /* [↑]  the distance between 2 vertices*/
   end     /*f*/                                 /*stick a fork in it,  we're all done. */
