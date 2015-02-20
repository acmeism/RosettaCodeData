/*REXX pgm reverses the order of tokens in a string, but not the letters*/
@.   =
@.1  = "---------- Ice and Fire ------------"
@.2  = ' '
@.3  = "fire, in end will world the say Some"
@.4  = "ice. in say Some"
@.5  = "desire of tasted I've what From"
@.6  = "fire. favor who those with hold I"
@.7  = ' '
@.8  = "... elided paragraph last ..."
@.9  = ' '
@.10 = "Frost Robert -----------------------"

  do   j=1  while  @.j\=='';  $=       /*process each "line"; nullify $.*/
    do k=1  for  words(@.j)            /*process each word in the string*/
    $=word(@.j,k) $                    /*prepend the word to a new line.*/
    end   /*k*/                        /* [↑]  could do this another way*/
  say $                                /*display newly constructed line.*/
  end     /*j*/                        /*stick a fork in it, we're done.*/
