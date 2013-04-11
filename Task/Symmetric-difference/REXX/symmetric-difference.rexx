/*REXX program to find the symmetric difference  (between two strings). */
a.=0                               /*falisify all the  a.k._  booleans. */
a= '["John", "Serena", "Bob", "Mary", "Serena"]'
b= '["Jim", "Mary", "John", "Jim", "Bob"]'
a.1=a;     say '──────────────list A =' a
a.2=b;     say '──────────────list B =' b
SD=  ;    SA=                                     /*Sym. Diff, Sym "And"*/
SD.=0;    SA.=0                                   /*falsify SD & SA bool*/

  do k=1  for 2                    /*process both lists (stemmed array).*/
  a.k=strip(strip(a.k,,"["),,']')  /*strip leading and trailing brackets*/

             do j=1  until a.k=''  /*parse names, they may have blanks. */
             a.k=strip(a.k,,',')                  /*strip comma (if any)*/
             parse var a.k '"' _ '"' a.k          /*get the list's name.*/
             a.k.j=_                              /*store the list name.*/
             a.k._=1                              /*make a boolean val. */
             end   /*j*/
  a.k.0=j-1                                       /*number of list names*/
  end              /*k*/
/*══════════════════════════════════════════════════find symmetric diff.*/
  do k=1  for 2                                   /*process both lists. */
  ko=word(2 1,k)                                  /*point to other list.*/

      do j=1  for a.k.0;      _=a.k.j             /*process list names. */
      if \a.ko._ & \SD._ then do                  /*if not in both...   */
                              SD=SD '"'_'",'      /*add to sym diff list*/
                              SD._=1              /*"trueify" a boolean.*/
                              end
      end   /*j*/
  end       /*k*/

SD= "["strip(space(SD),'T',",")']'                /*clean up and bracket*/
say;          say 'symmetric difference =' SD     /*show and tell the SD*/

/*══════════════════════════════════════════════════find symmetric AND. */
  do j=1  for a.1.0;            _=a.1.j           /*process A list names*/
  if a.1._ & a.2._ & \SA._ then do                /*if common to both...*/
                                SA=SA '"'_'",'    /*add to sym AND list.*/
                                SA._=1            /*"trueify" a boolean.*/
                                end
  end   /*j*/

SA="["strip(space(SA),'T',",")']'                 /*clean up and bracket*/
say;          say '       symmetric AND =' SA     /*show and tell the SA*/
                                       /*stick a fork in it, we're done.*/
