/*REXX program shows a list, asks user for a selection number (integer).*/

  do forever                           /*keep asking until response OK. */
  call list_create                     /*create the list from scratch.  */
  call list_show                       /*display (show) the list to user*/
  if #==0   then return ''             /*if empty list, then return null*/
  say right(' choose an item by entering a number from 1 ───►' #, 70, '═')
  parse pull x                         /*get the user's choice (if any).*/

    select
    when x=''             then call sayErr "a choice wasn't entered"
    when words(x)\==1     then call sayErr 'too many choices entered:'
    when \datatype(x,'N') then call sayErr "the choice isn't numeric:"
    when \datatype(x,'W') then call sayErr "the choice isn't an integer:"
    when x<1 | x>#        then call sayErr "the choice isn't within range:"
    otherwise             leave        /*this leaves the DO FOREVER loop*/
    end   /*select*/
  end     /*forever*/
                                       /*user might've entered 2. or 003*/
x=x/1                                  /*normalize the number (maybe).  */
say;  say 'you chose item' x": " #.x
return #.x                             /*stick a fork in it, we're done.*/
/*──────────────────────────────────LIST_CREATE─────────────────────────*/
list_create:   #.1='fee fie'           /*one method for list-building.  */
               #.2='huff and puff'
               #.3='mirror mirror'
               #.4='tick tock'
#=4                                    /*store number of choices in  #. */
return                                 /*(above) is just one convention.*/
/*──────────────────────────────────LIST_SHOW───────────────────────────*/
list_show: say                         /*display a blank line.          */
              do j=1  for #            /*display the list of choices.   */
              say '[item' j"] " #.j    /*display item # with its choice.*/
              end   /*j*/
say                                    /*display another blank line.    */
return
/*──────────────────────────────────SAYERR──────────────────────────────*/
sayErr:   say;     say  '***error!***'  arg(1)  x;       say;       return
