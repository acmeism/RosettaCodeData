/*REXX program  expresses numbers  from  intersecting number wheels  (or wheel sets).   */
@.=                                              /*initialize array to hold the wheels. */
parse arg lim @.1                                /*obtain optional arguments from the CL*/
if lim='' | lim=","  then lim= 20                /*Not specified?  Then use the default.*/
if @.1='' | @.1=","  then do;  @.1= ' A:  1 2 3 '
                               @.2= ' A:  1 B 2,    B:  3 4 '
                               @.3= ' A:  1 D D,    D:  6 7 8 '
                               @.4= ' A:  1 B C,    B:  3 4,    C:  5 B '
                          end
       do i=1  while @.i\='';  call run          /*construct wheel set and "execute" it.*/
       end   /*i*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
error: procedure; say;  say;    say '***error***'   arg(1);          say;   say;   exit 12
isLet: procedure; parse arg y;  return datatype(y, 'M') & length(y)==1   /*is a letter? */
isNum: procedure; parse arg y;  return datatype(y, 'N')                  /*is a number? */
/*──────────────────────────────────────────────────────────────────────────────────────*/
run: @wn= 'wheel name';     first=;      @noColon= "wheel name not followed by a colon:"
     @gn= 'gear name' ;     gear.=;      say copies("═", 79)
     say 'building wheel group for: '    @.i;    wheels= space(@.i);        upper wheels
        do #=1  while wheels\='';  parse var wheels  w gears "," wheels;    L= length(w)
        if L==2  then do;  !.#= left(w, 1)       /*obtain the one─character gear name.  */
                           if right(w, 1)\==':'  then call error @noColon  w
                           if \isLet(!.#)        then call error @wn "not a letter:"  w
                      end
                 else call error "first token isn't a"   @wn':'     w
        if #==1  then first= !.1                 /*Is this is the 1st wheel set?  Use it*/
        if first==''  then call error "no wheel name was specified."
        n= !.#                                   /*obtain the name of the 1st wheel set.*/
        gear.n.0= 1                              /*initialize default 1st gear position.*/
        say '   setting gear.name:'     n     "    gears=" gears
           do g=1  for words(gears);         _= word(gears, g)
           if isNum(_)  |  isLet(_)  then do;  gear.n.g= _;  iterate;  end
           call error  @gn  "isn't a number or a gear name:"  _
           end   /*g*/
        end      /*#*/
    say;                  say center(' running the wheel named '  first" ", 79, '─');   $=
        do dummy=0  by 0  until words($)==lim;           n= first
        z= gear.n.0;               x= gear.n.z;          z= z + 1
        gear.n.0= z;      if gear.n.z==''  then gear.n.0= 1
        if isNum(x)  then do;     $= $ x;    iterate;    end   /*found a number, use it.*/
        xx= x                                    /*different gear, keep switching 'til X*/
           do forever;            nn= xx
           if gear.nn.0==''  then call error "a gear is using an unknown gear name:"  x
           zz= gear.nn.0;         xx= gear.nn.zz
           zz= zz + 1;   gear.nn.0= zz;   if gear.nn.zz==''  then gear.nn.0= 1
           if isNum(xx)  then do;  $= $ xx;  iterate dummy;  end
           end   /*forever*/                     /* [↑]  found a number,  now use FIRST.*/
        end      /*dummy*/                       /*"DUMMY"  is needed for the  ITERATE. */
     say '('lim "results): "  strip($);      say;          say;          return
