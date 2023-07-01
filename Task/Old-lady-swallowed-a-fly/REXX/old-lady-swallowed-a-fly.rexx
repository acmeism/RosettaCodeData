/*REXX program displays  song lyrics  for:   "I Know an Old Lady who Swallowed a Fly".  */
sw= 79                                           /*the width of the terminal screen, -1.*/
@.=;            @.1 = "I don't know why she swallowed a fly,"
                @.2 = "That wriggled and jiggled and tickled inside her.";    @.2.0=.
                @.3 = "How absurd to swallow a bird!"
                @.4 = "Imagine that, to swallow a cat!"
                @.5 = "My, what a hog, to swallow a dog!"
                @.6 = "Just opened her throat and swallowed a goat!"
                @.7 = "I wonder how she swallowed a cow?!"
                @.8 = "She's dead, of course!!"
$ = 'fly spider bird cat dog goat cow horse'
#= words($)                                      /*#:  number of animals to be swallowed*/

  do j=1  for #;        say
  say center('I know an old lady who swallowed a'     word($, j)",",  sw)
  if j\==1  then  say center(@.j, sw)
  if j ==#  then leave                           /*Is this the last verse?   We're done.*/
                      do k=j  to 2  by -1;      km= k-1;              ??= word($, km)','
                      say center('She swallowed the'   word($,k)  "to catch the"   ??, sw)
                      if @.km.0\==''  then say center(@.km, sw)
                      end   /*k*/                /* [↑]  display the lyrics of the song.*/
  say center(@.1, sw)
  say center("I guess she'll die.", sw)
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
