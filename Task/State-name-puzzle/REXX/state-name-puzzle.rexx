/*REXX pgm: state name puzzle, rearrange 2 state's names──►2 new states.*/
!='Alabama,  Alaska, Arizona,  Arkansas, California,    Colorado, Connecticut,       Delaware, Florida, Georgia,',
  'Hawaii,   Idaho,  Illinois, Indiana,  Iowa, Kansas,  Kentucky, Louisiana,  Maine, Maryland, Massachusetts,   ',
  'Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, New Hampshire, New Jersey, New Mexico,',
  'New York, North Carolina,  North Dakota,  Ohio, Oklahoma, Oregon, Pennsylvania, Rhode Island, South Carolina,',
  'South Dakota,  Tennessee,  Texas,  Utah,  Vermont,   Virginia, Washington, West Virginia, Wisconsin,  Wyoming'

parse arg xtra;    !=! ',' xtra           /*add optional fictitious ones*/
@abcU='ABCDEFGHIJKLMNOPQRSTUVWXYZ';     !=space(!)    /*ABCs, state list*/
deads=0;   dups=0;   L.=0;   !orig=!;   z=0;   @@.=   /*initialize stuff*/

  do de=0 to 1;    !=!orig;    @.=        /*use the original state list.*/

    do states=0  until !==''              /*parse 'til da cows come home*/
    parse var ! x ',' !;   x=space(x)     /*remove all blanks from state*/
    if @.x\=='' then do                   /*state was already specified.*/
                     if de then iterate   /*don't tell error if 2nd pass*/
                     dups=dups+1          /*bump the duplicate counter. */
                     say 'ignoring the 2nd naming of the state: ' x
                     iterate
                     end
    @.x=x                                 /*indicate this state exists. */
    y=space(x,0);  upper y;  yLen=length(y)

    if de then do
                  do j=1 for yLen         /*see if it's a dead-end state*/
                  _=substr(y,j,1)         /* _ is some state character. */
                  if L._\==1 then iterate /*if count ¬1, state is O.K.  */
                  say 'removing dead-end state  [which has the letter ' _"]: "  x
                  deads=deads+1           /*bump # of dead-ends states. */
                  iterate states
                  end   /*j*/
               z=z+1                      /*bump counter of the states. */
               #.z=y;  ##.z=x             /*assign state name; &original*/
               end
          else do k=1 for yLen            /*inventorize state's letters.*/
               _=substr(y,k,1); L._=L._+1 /*count each letter in state. */
               end   /*k*/

    end   /*states*/
  end     /*de*/

say;                  do i=1  for z       /*list states in order given. */
                      say right(i,9) ##.i
                      end   /*i*/

                   say; say z 'state name's(z)          "are useable."
if dups \==0 then  say dups  'duplicate of a state's(dups)  'ignored.'
if deads\==0 then  say deads 'dead-end state's(deads)       'deleted.'
say
sols=0                                    /*number of solutions found.  */

     do j=1 for z  /*◄────────────────────────────────────────────────┐ */
                                         /*look for mix&match states. │ */
       do k=j+1 to z                     /* ◄─── state K,  state J ►──┘ */
       if #.j<<#.k  then JK=#.j || #.k                   /*proper order.*/
                    else JK=#.k || #.j                   /*state J || K */

         do m=1 for z;     if m==j | m==k then iterate   /*no overlaps. */
         if verify(#.m,jk)\==0            then iterate   /*is possible? */
         nJK=elider(JK,#.m)           /*new JK, after eliding #.m chars.*/

           do n=m+1 to z;  if n==j | n==k then iterate   /*no overlaps. */
           if verify(#.n,nJK)\==0         then iterate   /*is possible? */
           if elider(nJK,#.n)\==''        then iterate   /*leftovers ?  */
           if #.m<<#.n  then MN=#.m || #.n               /*proper order.*/
                        else MN=#.n || #.m               /*state M || N */
           if @@.JK.MN\=='' | @@.MN.JK\=='' then iterate /*done before? */
           say 'found: '  ##.j',' ##.k     "  ──►  "     ##.m','  ##.n
           @@.JK.MN=1                 /*indicate this solution as found.*/
           sols=sols+1                /*bump the number of solutions.   */
           end   /*n*/
         end     /*m*/
       end       /*k*/
     end         /*j*/
say                                    /*show blank line; easier reading*/
if sols==0  then sols='No'             /*use mucher gooder (sic) English*/
say sols 'solution's(sols) "found."    /*display the number of solutions*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────ELIDER─────────────────────────────*/
elider: parse arg hay,pins             /*remove letters (pins) from hay.*/
                            do e=1 for length(pins);  _=substr(pins,e,1)
                            p=pos(_,hay);             if p==0 then iterate
                            hay=overlay(' ',hay,p)    /*remove a letter.*/
                            end   /*e*/
return space(hay,0)                                   /*remove blanks.  */
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1 then return arg(3);return word(arg(2) 's',1)  /*plurals.*/
