/*REXX program searches a collection of strings   (an array of periodic table elements).*/
hay.=0                                           /*initialize the haystack collection.  */
hay._sodium       = 1
hay._phosphorous  = 1
hay._californium  = 1
hay._copernicium  = 1
hay._gold         = 1
hay._thallium     = 1
hay._carbon       = 1
hay._silver       = 1
hay._copper       = 1
hay._helium       = 1
hay._sulfur       = 1
                                                 /*underscores (_) are used to NOT ...  */
                                                 /*   ... conflict with variable names. */

needle  = 'gold'                                 /*we'll be looking for the gold.       */

Xneedle = '_'needle                              /*prefix an underscore (_)  character. */
upper Xneedle                                    /*uppercase:  how REXX stores them.    */

                                                 /*alternative version of above:        */
                                                 /*       Xneedle=translate('_'needle)  */

found=hay.Xneedle                                /*this is it, it's found (or maybe not)*/

if found  then return j                          /*return the haystack  index  number.  */
          else say  needle  "wasn't found in the haystack!"
return 0                                         /*indicates the needle  wasn't  found. */
