/*REXX program demonstrates some  common   SET   functions.             */
truth.0='false';  truth.1='true'       /*common names for truth table.  */
set.=                                  /*order of sets isn't important. */

call setAdd 'prime',2 3 2 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
call setSay 'prime'                   /*a small set of primes (numbers).*/

call setAdd 'emirp',97 97 89 83 79 73 71 67 61 59 53 47 43 41 37 31 29 23 19 17 13 11 7 5 3 2
call setSay 'emirp'                   /*a small set of baclward primes. */

call setAdd 'happy',1 7 10 13 19 23 28 31 32 44 49 68 70 79 82 86 91 100 94 97 97 97 97 97
call setSay 'happy'                   /*a small set of happy numbers.   */

      do j=11  to 100  by 10          /*see if PRIME contains some nums*/
      call setHas 'prime',j
      say '             prime contains' j":" truth.result
      end   /*j*/

call setUnion  'prime','happy','eweion'; call setSay 'eweion'
call setCommon 'prime','happy','common'; call setSay 'common'
call setDiff   'prime','happy','diff'  ; call setSay 'diff'
call setSubset 'prime','happy'         ; say '       prime is a subset of happy:' truth.result
call setEqual  'prime','emirp'         ; say '       prime is  equal   to emirp:' truth.result
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
setHas:    procedure expose set.; arg _ .,! .;return wordpos(!,set._)\==0
setAdd:    return set$('add'   ,arg(1),arg(2))
setDiff:   return set$('diff'  ,arg(1),arg(2),arg(3))
setSay:    return set$('say'   ,arg(1),arg(2))
setUnion:  return set$('union' ,arg(1),arg(2),arg(3))
setCommon: return set$('common',arg(1),arg(2),arg(3))
setEqual:  return set$('equal' ,arg(1),arg(2))
setSubset: return set$('subSet',arg(1),arg(2))
/*──────────────────────────────────set$ subroutine─────────────────────*/
set$: procedure expose set.;  arg $,_1,_2,_3;  set_=set._1; t=_3; s=t; !=1
if $=='SAY'   then do;   say '[set.'_1"]="set._1;   return set._1;   end
if $=='UNION' then do
                   call set$ 'add',_3,set._1
                   call set$ 'add',_3,set._2
                   return set._3
                   end
add=$=='ADD';common=$=='COMMON';diff=$=='DIFF';eq=$=='EQUAL';subset=$=='SUBSET'
if common | diff | eq | subset then s=_2
if add then do;  set_=_2;  t=_1;  s=_1;  end

    do j=1  for words(set_);    _=word(set_,j);   has=wordpos(_,set.s)\==0
    if (add    & \has) |,
       (common &  has) |,
       (diff   & \has)       then set.t=space(set.t _)
    if (eq | subset) & \has  then return 0
    end    /*j*/

if subset  then return 1
if eq  then  if  arg()>3  then return 1
                          else return set$('equal',_2,_1,1)
return set.t
