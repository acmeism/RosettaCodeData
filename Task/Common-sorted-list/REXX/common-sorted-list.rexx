/*REXX pgm creates and displays a  common sorted list  of a specified collection of sets*/
parse arg a                                      /*obtain optional arguments from the CL*/
if a='' | a=","  then a= '[5,1,3,8,9,4,8,7]  [3,5,9,8,4]  [1,3,7,9]'     /*default sets.*/
x= translate(a, ,'],[')                          /*extract elements from collection sets*/
se= words(x)
#= 0;            $=                              /*#: number of unique elements; $: list*/
$=                                               /*the list of common elements (so far).*/
    do j=1  for se;  _= word(x, j)               /*traipse through all elements in sets.*/
    if wordpos(_, $)>0  then iterate             /*Is element in the new list? Yes, skip*/
    $= $ _;   #= # + 1;    @.#= _                /*add to list; bump counter; assign──►@*/
    end   /*j*/
$=
call eSort #                                     /*use any short (small)  exchange sort.*/
                 do k=1  for #;   $= $  @.k      /*rebuild the $ list, it's been sorted.*/
                 end   /*k*/

say 'the list of sorted common elements in all sets: ' "["translate(space($), ',', " ")']'
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose @.; arg h 1 z; do while h>1; h= h%2; do i=1  for z-h; j= i; k= h+i
        do while @.k<@.j; t=@.j; @.j=@.k; @.k=t; if h>=j then leave; j=j-h; k=k-h; end;end
        end;     return                          /*this sort was used 'cause of brevity.*/
