/*REXX program demonstrates the classic hash join algorithm for two relations.*/
               S.  =                    ;         R.  =
               S.1 = 27 'Jonah'         ;         R.1 = 'Jonah Whales'
               S.2 = 18 'Alan'          ;         R.2 = 'Jonah Spiders'
               S.3 = 28 'Glory'         ;         R.3 = 'Alan Ghosts'
               S.4 = 18 'Popeye'        ;         R.4 = 'Alan Zombies'
               S.5 = 28 'Alan'          ;         R.5 = 'Glory Buffy'
hash.=                                 /*initialize the  hash  table (array). */
       do #=1  while S.#\=='';   parse var S.# age name  /*extract information*/
       hash.name=hash.name #           /*build a hash table entry with its idx*/
       end   /*#*/                     /* [↑]  REXX does the heavy work here. */
#=#-1                                  /*adjust for the DO loop  (#)  overage.*/
       do j=1  while R.j\==''          /*process a nemesis for a name element.*/
       parse var R.j x nemesis         /*extract the name  and  its nemesis.  */
       if hash.x==''  then do;   #=#+1 /*Not in hash?  Then a new name; bump #*/
                           S.#=',' x   /*add a new name to the    S   table.  */
                           hash.x=#    /* "  "  "    "   "  "   hash    "     */
                           end         /* [↑]  this DO isn't used today.      */
            do k=1  for words(hash.x);  _=word(hash.x,k)    /*get the pointer.*/
            S._=S._  nemesis           /*add the nemesis ──► applicable hash. */
            end   /*k*/
       end        /*j*/
_='─'                                  /*the character used for the separator.*/
pad=left('',6-2)                       /*spacing used in header and the output*/
say  pad  center('age',3)  pad  center('name',20  }  pad  center('nemesis',30  )
say  pad  center('───',3)  pad  center(''    ,20,_)  pad  center(''       ,30,_)

     do n=1  for #;     parse  var  S.n    age  name  nems  /*get information.*/
     if nems==''  then iterate                              /*No nemesis? Skip*/
     say pad  right(age,3)  pad  center(name,20)  pad nems  /*display an  S.  */
     end   /*n*/
                                       /*stick a fork in it,  we're all done. */
