CREATE C 0 ,
: .,   C @ IF ." , " THEN  1 C ! ;
: .TIME ( n --)
   [ 60 60 24 7 * * * ]L /MOD ?DUP-IF ., . ." wk" THEN
   [ 60 60 24   * *   ]L /MOD ?DUP-IF ., . ." d" THEN
   [ 60 60      *     ]L /MOD ?DUP-IF ., . ." hr" THEN
   [ 60               ]L /MOD ?DUP-IF ., . ." min" THEN
                              ?DUP-IF ., . ." sec" THEN  0 C ! ;
