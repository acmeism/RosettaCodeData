thing =  37
thing = '37'                      /*this is exactly the same as above.          */
thing = "37"                      /*this is exactly the same as above also.     */

say 'base  10='        thing
say 'base   2=' x2b(d2x(thing))
say 'base  16='    d2x(thing)
say 'base 256='    d2c(thing)   /*the output shown is ASCII (or maybe EBCDIC).*/
