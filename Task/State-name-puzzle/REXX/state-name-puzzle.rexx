/*REXX program  (state name puzzle)  rearranges two state's names ──► two new states.   */
!='Alabama,  Alaska, Arizona,  Arkansas, California,    Colorado, Connecticut,       Delaware, Florida, Georgia,',
  'Hawaii,   Idaho,  Illinois, Indiana,  Iowa, Kansas,  Kentucky, Louisiana,  Maine, Maryland, Massachusetts,   ',
  'Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, New Hampshire, New Jersey, New Mexico,',
  'New York, North Carolina,  North Dakota,  Ohio, Oklahoma, Oregon, Pennsylvania, Rhode Island, South Carolina,',
  'South Dakota,  Tennessee,  Texas,  Utah,  Vermont,   Virginia, Washington, West Virginia, Wisconsin,  Wyoming'
parse arg xtra;    !=! ',' xtra                     /*add optional  (fictitious)  names.*/
@abcU= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';     !=space(!) /*!: the state list, no extra blanks*/
deads=0;    dups=0;    L.=0;     !orig=!;      @@.= /*initialize some REXX variables.   */
z=0                                                 /* [↑]  elide  dend─end (DE) states.*/
    do de=0  for 2;              !=!orig            /*use original state list for each. */
    @.=
        do states=0  by 0  until !==''              /*parse until the cows come home.   */
        parse var !  x  ','  !;       x=space(x)    /*remove all blanks from state name.*/
        if @.x\==''  then do                        /*was state was already specified?  */
                          if de  then iterate       /*don't tell error if doing 2nd pass*/
                          dups=dups + 1             /*bump the duplicate counter.       */
                          say 'ignoring the 2nd naming of the state: '    x;      iterate
                          end
        @.x=x                                       /*indicate this state name exists.  */
        y=space(x,0);    upper y;    yLen=length(y) /*get upper name with no spaces; Len*/
        if de  then do                              /*Is the firstt pass?  Then process.*/
                         do j=1  for yLen           /*see if it's a dead─end state name.*/
                         _=substr(y, j, 1)          /* _:  is some state name character.*/
                         if L._ \== 1  then iterate /*Count ¬ 1?  Then state name is OK.*/
                         say 'removing dead─end state  [which has the letter '   _"]: "  x
                         deads=deads + 1            /*bump number of dead─ends states.  */
                         iterate states             /*go and process another state name.*/
                         end   /*j*/
                    z=z+1                           /*bump counter of the state names.  */
                    #.z=y;  ##.z=x                  /*assign state name;  also original.*/
                    end
               else do k=1  for yLen                /*inventorize letters of state name.*/
                    _=substr(y,k,1);   L._=L._ + 1  /*count each letter in state name.  */
                    end   /*k*/
        end   /*states*/                            /*the index STATES isn't incremented*/
    end       /*de*/
call list                                           /*list state names in order given.  */
                   say z     'state name's(z)                "are useable."
if dups \==0  then say dups  'duplicate of a state's(dups)   'ignored.'
if deads\==0  then say deads 'dead─end state's(deads)        'deleted.'
sols=0                                              /*number of solutions found (so far)*/
say                                                 /*[↑]  look for mix and match states*/
     do j=1  for z     /* ◄──────────────────────────────────────────────────────────┐  */
       do k=j+1  to z                               /* ◄─── state K,  state J  ►─────┘  */
       if #.j<<#.k  then JK=#.j || #.k              /*is the state in the proper order? */
                    else JK=#.k || #.j              /*No,  then use the new state name. */
         do m=1  for z; if m==j | m==k then iterate /*no state  overlaps  are allowed.  */
         if verify(#.m, jk) \== 0      then iterate /*is this state name even possible? */
         nJK=elider(JK, #.m)                        /*a new JK, after eliding #.m chars.*/
           do n=m+1  to z; if n==j | n==k then iterate      /*no overlaps are allowed.  */
           if verify(#.n, nJK) \== 0      then iterate      /*is it possible?           */
           if elider(nJK, #.n) \== ''     then iterate      /*any leftovers letters?    */
           if #.m<<#.n  then MN=#.m || #.n                  /*is it in the proper order?*/
                        else MN=#.n || #.m                  /*we found a new state name.*/
           if @@.JK.MN\=='' | @@.MN.JK\==""  then iterate   /*was it done before?       */
           say 'found: '      ##.j','     ##.k       "  ───►  "        ##.m','      ##.n
           @@.JK.MN=1                            /*indicate this solution as being found*/
           sols=sols+1                           /*bump the number of solutions found.  */
           end   /*n*/
         end     /*m*/
       end       /*k*/
     end         /*j*/
say                                              /*show a blank line for easier reading.*/
if sols==0  then sols= 'No'                      /*use mucher gooder (sic) Englishings. */
say sols  'solution's(sols)    "found."          /*display the number of solutions found*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
elider: parse arg hay,pins                       /*remove letters (pins) from haystack. */
                            do e=1  for length(pins);    p=pos( substr( pins, e, 1),  hay)
                            if p==0  then iterate   ;    hay=overlay(' ', hay, p)
                            end   /*e*/          /* [↑]  remove a letter from haystack. */
        return space(hay, 0)                     /*remove blanks from the haystack.     */
/*──────────────────────────────────────────────────────────────────────────────────────*/
list:   say;   do i=1  for z;   say right(i, 9)   ##.i;   end;            say;      return
s:      if arg(1)==1  then return arg(3);    return word(arg(2) 's', 1)    /*pluralizer.*/
