   addCUSIPcheckdigit '68389X10'
68389X105
   verifyCUSIPcheckdigit '68389X106'
0
   verifyCUSIPcheckdigit '68389X105'
1
   samples =: '037833100', '17275R102', '38259P508', '594918104', '68389X106',: '68389X105'
   samples ; verifyCUSIPcheckdigit"1 samples
┌─────────┬─┐
│037833100│1│
│17275R102│1│
│38259P508│1│
│594918104│1│
│68389X106│0│
│68389X105│1│
└─────────┴─┘
