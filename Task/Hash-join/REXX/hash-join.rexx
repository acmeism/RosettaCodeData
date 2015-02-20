/*REXX pgm demonstrates the classic hash join algorithm for 2 relations.*/
 S.  =                       ;     R.  =
 S.1 = 27 'Jonah'            ;     R.1 = 'Jonah Whales'
 S.2 = 18 'Alan'             ;     R.2 = 'Jonah Spiders'
 S.3 = 28 'Glory'            ;     R.3 = 'Alan Ghosts'
 S.4 = 18 'Popeye'           ;     R.4 = 'Alan Zombies'
 S.5 = 28 'Alan'             ;     R.5 = 'Glory Buffy'
hash.=                                 /*initialize the  hash  table.   */
       do #=1  while S.#\=='';     parse var S.# age name /*extract info*/
       hash.name=hash.name #           /*build a hash table entry.      */
       end   /*#*/                     /* [↑]  REXX does the heavy work.*/
#=#-1                                  /*adjust for DO loop (#) overage.*/
       do j=1  while R.j\==''          /*process a nemesis for a name.  */
       parse var R.j x nemesis         /*extract name and it's nemesis. */
       if hash.x==''  then do          /*Not in hash?   Then a new name.*/
                           #=#+1       /*bump the number of  S entries. */
                           S.#=',' x   /*add new name to the S table.   */
                           hash.x=#    /*add new name to the hash table.*/
                           end         /* [↑]  this DO isn't used today.*/
            do k=1  for words(hash.x);  _=word(hash.x,k)  /*get pointer.*/
            S._=S._  nemesis           /*add nemesis──► applicable hash.*/
            end   /*k*/
       end        /*j*/
_='─'                                  /*character used for separater.  */
pad=left('',6-2)                       /*spacing used in hdr/sep/output.*/
say pad center('age',3) pad center('name',20)   pad center('nemesis',30)
say pad center('───',3) pad center(''    ,20,_) pad center(''       ,30,_)

     do n=1  for #;     parse  var  S.n    age  name  nems  /*get info. */
     if nems==''  then iterate         /*if no nemesis, then don't show.*/
     say pad  right(age,3)  pad  center(name,20)  pad nems  /*show an S.*/
     end   /*n*/
                                       /*stick a fork in it, we're done.*/
