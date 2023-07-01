   sum =: +/
   prod =: */
   count =: #

   nameToDispatch =: 'sum'    NB. pick a name already defined

   ". nameToDispatch,' 1 2 3'
6
   nameToDispatch~ 1 2 3
6
   nameToDispatch (128!:2) 1 2 3
6

   nameToDispatch =: 'count'  NB. pick another name

   ". nameToDispatch,' 1 2 3'
3
   nameToDispatch~ 1 2 3
3
   nameToDispatch (128!:2) 1 2 3
3
