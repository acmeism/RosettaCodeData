/*REXX pgm (state name puzzle) rearranges two state's names ──► two new states*/
!='Alabama,  Alaska, Arizona,  Arkansas, California,    Colorado, Connecticut,       Delaware, Florida, Georgia,',
  'Hawaii,   Idaho,  Illinois, Indiana,  Iowa, Kansas,  Kentucky, Louisiana,  Maine, Maryland, Massachusetts,   ',
  'Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, New Hampshire, New Jersey, New Mexico,',
  'New York, North Carolina,  North Dakota,  Ohio, Oklahoma, Oregon, Pennsylvania, Rhode Island, South Carolina,',
  'South Dakota,  Tennessee,  Texas,  Utah,  Vermont,   Virginia, Washington, West Virginia, Wisconsin,  Wyoming'

parse arg xtra;    !=! ',' xtra           /*add optional  (fictitious)  names.*/
@abcU='ABCDEFGHIJKLMNOPQRSTUVWXYZ';     !=space(!)    /*ABCs;  the state list.*/
deads=0;   dups=0;   L.=0;   !orig=!;   z=0;   @@.=   /*initialize some vars. */

  do de=0 for 2;     !=!orig;    @.=      /*use original state list for each. */

    do states=0  until !==''              /*parse until the cows come home.   */
    parse var ! x ',' !;   x=space(x)     /*remove all blanks from state name.*/
    if @.x\=='' then do                   /*was state was already specified?  */
                     if de  then iterate  /*don't tell error if doing 2nd pass*/
                     dups=dups+1          /*bump the duplicate counter.       */
                     say 'ignoring the 2nd naming of the state: '    x
                     iterate
                     end
    @.x=x                                 /*indicate this state name exists.  */
    y=space(x,0); upper y; yLen=length(y) /*get upper name with no spaces; Len*/

    if de then do                         /*Is the 1st pass?   Then process.  */
                  do j=1  for yLen        /*see if it's a dead─end state name.*/
                  _=substr(y,j,1)         /* _:  is some state name character.*/
                  if L._\==1 then iterate /*Count ¬1?  Then state name is O.K.*/
                  say 'removing dead─end state  [which has the letter ' _"]: " x
                  deads=deads+1           /*bump number of dead─ends states.  */
                  iterate states          /*go and process another state name.*/
                  end   /*j*/
               z=z+1                      /*bump counter of the state names.  */
               #.z=y;  ##.z=x             /*assign state name;  and original. */
               end
          else do k=1  for yLen           /*inventorize state name's letters. */
               _=substr(y,k,1); L._=L._+1 /*count each letter in state name.  */
               end   /*k*/

    end   /*states*/
  end     /*de*/

say;                  do i=1  for z       /*list state names in order given.  */
                      say right(i,9) ##.i /*show the index number, state name.*/
                      end   /*i*/

                   say;    say z  'state name's(z)          "are useable."
if dups \==0  then say dups  'duplicate of a state's(dups)  'ignored.'
if deads\==0  then say deads 'dead─end state's(deads)       'deleted.'
say
sols=0                                    /*number of solutions found (so far)*/

     do j=1  for z  /*◄─────────────────────────────────────────────────────┐ */
                                          /*look for mix and match states.  │ */
       do k=j+1  to z                     /* ◄─── state K,  state J ►───────┘ */
       if #.j<<#.k  then JK=#.j || #.k                   /*is in proper order?*/
                    else JK=#.k || #.j                   /*use new state name.*/

         do m=1  for z;    if m==j | m==k then iterate   /*no overlaps allowed*/
         if verify(#.m,jk)\==0            then iterate   /*is this possible?  */
         nJK=elider(JK,#.m)            /*new JK, after eliding #.m characters.*/

           do n=m+1  to z; if n==j | n==k then iterate   /*no overlaps allowed*/
           if verify(#.n,nJK)\==0         then iterate   /*is it possible?    */
           if elider(nJK,#.n)\==''        then iterate   /*leftovers letters? */
           if #.m<<#.n  then MN=#.m || #.n               /*is in proper order?*/
                        else MN=#.n || #.m               /*a new state name.  */
           if @@.JK.MN\=='' | @@.MN.JK\=='' then iterate /*was it done before?*/
           say 'found: '   ##.j',' ##.k     "  ───►  "      ##.m','    ##.n
           @@.JK.MN=1                  /*indicate this solution as being found*/
           sols=sols+1                 /*bump the number of solutions found.  */
           end   /*n*/
         end     /*m*/
       end       /*k*/
     end         /*j*/
say                                    /*show a blank line for easier reading.*/
if sols==0  then sols='No'             /*use mucher gooder (sic) Englishings. */
say sols 'solution's(sols) "found."    /*display the number of solutions found*/
exit                                   /*stick a fork in it,  we're all done. */
/*───────────────────────────────────ELIDER───────────────────────────────────*/
elider: parse arg hay,pins             /*remove letters (pins) from haystack. */

                      do e=1  for length(pins);   p=pos(substr(pins,e,1), hay)
                      if p==0  then iterate   ;   hay=overlay(' ',hay,p)
                      end   /*e*/                     /* [↑]  remove a letter.*/
return space(hay,0)                                   /*remove blanks from hay*/
/*──────────────────────────────────S subroutine──────────────────────────────*/
s: if arg(1)==1 then return arg(3);return word(arg(2) 's',1)     /*pluralizer.*/
