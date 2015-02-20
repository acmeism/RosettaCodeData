/*REXX program to display the lyrics for the song: "I Know an Old Lady".*/
@ = 'fly spider bird cat dog goat cow horse'             ;    #=words(@)
first = "I know an old lady who swallowed a"             ;    sw=79
@ate  = 'She swallowed the';    @2catch= "to catch the"  ;    @.=
@.1 = "I don't know why she swallowed a fly,"
@.2 = "That wriggled and jiggled and tickled inside her.";    @.2.0=1
@.3 = "How absurd to swallow a bird!"
@.4 = "Imagine that, to swallow a cat!"
@.5 = "My, what a hog, to swallow a dog!"
@.6 = "Just opened her throat and swallowed a goat!"
@.7 = "I wonder how she swallowed a cow?!"
@.8 = "She's dead, of course!!"

  do j=1  for #;                    animal=word(@,j);         say
  say center(first animal',',sw);   if j\==1  then  say center(@.j, sw)
  if j==# then leave
                       do k=j  to 2  by -1;           km=k-1
                       say center(@ate word(@,k) @2catch word(@,km)',',sw)
                       if @.km.0\==''  then say center(@.km, sw)
                       end   /*k*/
  say center(@.1, sw)
  say center("I guess she'll die.", sw)
  end   /*j*/
                                       /*stick a fork in it, we're done.*/
